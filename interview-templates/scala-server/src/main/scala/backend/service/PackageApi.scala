package backend.service

import backend.database.DocumentDAO
import cats.data.Validated._
import cats.effect.IO
import fs2.text
import io.circe.syntax._
import org.http4s.HttpRoutes
import org.http4s.circe.CirceEntityCodec.circeEntityEncoder
import org.http4s.circe._
import org.http4s.dsl.Http4sDsl
import org.log4s.{ getLogger, Logger }

object PackageApi {
  val logger: Logger     = getLogger
  val dsl: Http4sDsl[IO] = new Http4sDsl[IO] {}; import dsl._

  def apply(dd: PackageDAO): HttpRoutes[IO] = {
    HttpRoutes.of[IO] {
      case GET -> Root / id =>
        for {
          result <- dd.searchWithId(id)
          resp <- result match {
            case Left(e) =>
              logger.error(e)(s"failed to find $id")
              InternalServerError(e.getMessage)
            case Right(found) =>
              Ok(found.asJson)
          }
        } yield resp
      case req @ POST -> Root / id =>
        for {
          body   <- req.body.through(text.utf8.decode).compile.string
          result <- dd.upsert(id, body)
          resp <- result match {
            case Left(e) =>
              logger.error(e)(s"failed to add '$id' with body '$body'")
              InternalServerError(e.getMessage)
            case Right(inserted) =>
              Ok(inserted)
          }
        } yield resp
      case DELETE -> Root / "reset" =>
        for {
          result <- dd.resetDocumentsTable
          resp <- result match {
            case Invalid(es) =>
              val messages = es.map { e =>
                logger.error(e)("failed to reset documents table")
                e.getMessage
              }
              InternalServerError(messages.mkString("\n"))
            case Valid(inserted) =>
              Ok(inserted) // I know this is a list, i only return it for debugging.
          }
        } yield resp
    }
  }
}
