package backend.model

import com.comcast.ip4s.{ Host, Port }
import pureconfig._
import pureconfig.generic.auto._

case class Config(
    ip: Host,
    port: Port,
    dbAddress: String,
)

object Config {

  implicit val hostReader =
    ConfigReader.fromString(ConvertHelpers.optF(Host.fromString(_)))
  implicit val portReader =
    ConfigReader.fromString(ConvertHelpers.optF(Port.fromString(_)))

  def load() = ConfigSource.default.loadOrThrow[Config]
}
