package backend

import backend.database.DocumentDAO
import backend.model.Config
import backend.service.PackageApi,
import cats.effect.{ Async, IO, Resource }
import cats.syntax.all._
import doobie.util.transactor.Transactor
import fs2.Stream
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.implicits._
import org.http4s.server.Router
import org.http4s.server.middleware.Logger
import org.log4s.getLogger

object Server {
  val logger = getLogger
  def stream(conf: Config): Stream[IO, Nothing] = {
    for {
      client <- Stream.resource(EmberClientBuilder.default[IO].build)
      xa = Transactor.fromDriverManager[IO](
        driver = "org.sqlite.JDBC",
        url = conf.dbAddress,
        user = "",
        pass = "",
      )
      dd = new DocumentDAO(xa)

      httpApp = Router(
        "/v1" -> PackageApi(dd),
      ).orNotFound

      finalHttpApp = Logger.httpApp(true, true)(httpApp)

      exitCode <- Stream.resource(
        EmberServerBuilder
          .default[IO]
          .withHost(conf.ip)
          .withPort(conf.port)
          .withHttpApp(finalHttpApp)
          .build >>
          Resource.eval(Async[IO].never),
      )
    } yield exitCode
  }.drain
}
