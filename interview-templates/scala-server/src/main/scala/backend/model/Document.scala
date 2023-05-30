package backend.model

import cats.effect.Concurrent
import doobie.{ Read, Write }
import io.circe.generic.semiauto.{ deriveDecoder, deriveEncoder }
import io.circe.{ Decoder, Encoder }
import org.http4s.circe.{ jsonEncoderOf, jsonOf }
import org.http4s.{ EntityDecoder, EntityEncoder }

import java.time.OffsetDateTime

case class Document(id: String, body: String, modifiedAt: OffsetDateTime)
object Document {
  // Circe
  implicit val docDecoder: Decoder[Document] = deriveDecoder[Document]
  implicit val docEncoder: Encoder[Document] = deriveEncoder[Document]

  implicit def docEntityDecoder[F[_]: Concurrent]: EntityDecoder[F, Document] = jsonOf
  implicit def docEntityEncoder[F[_]]: EntityEncoder[F, Document] = jsonEncoderOf

  // Doobie
  implicit val docRead: Read[Document] = Read[(String, String, String)].map {
    case (id, body, time) => new Document(id, body, OffsetDateTime.parse(time))
  }
  implicit val docWrite: Write[Document] =
    Write[(String, String, String)].contramap(d =>
      (d.id, d.body, d.modifiedAt.toString),
    )
}
