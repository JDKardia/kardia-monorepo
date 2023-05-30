package backend

import backend.model.Config
import cats.effect.{ ExitCode, IOApp }
import org.log4s.getLogger

object Main extends IOApp {
  val logger = getLogger
  def run(args: List[String]) = {
    Server.stream(Config.load()).compile.drain.as(ExitCode.Success)
  }
}
