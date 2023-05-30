package interview
import cats._
import cats.data._
import cats.implicits._
import doobie._
import doobie.implicits._
import cats.effect.IO
import cats.effect.unsafe.implicits.global
import cats.implicits.catsSyntaxTuple2Semigroupal
import io.circe.Json
import pprint.pprintln
import io.circe.generic.auto._
import io.circe.syntax._
import io.circe.parser._
import doobie._
import doobie.implicits._

import java.time.OffsetDateTime
object Main extends App {

  import DB._
  import Model._

  val p = Point(1, 2)
  p.asJson.as[Point].map(pprintln(_))

  insertPoint(Point(1, 2))
  pprintln(getPoints())
  insertKeyVal("one", "one".asJson)
  insertKeyVal("two", "two".asJson)
  pprintln(getKeyVal("one"))
  pprintln(getKeyVals())
}
object Model {
  case class Point(x: Int, y: Int)
  object Point {
    implicit val pointRead: Read[Point] = Read[(Int, Int)].map { case (x, y) =>
      new Point(x, y)
    }
    implicit val pointWrite: Write[Point] = Write[(Int, Int)].contramap(p => (p.x, p.y))
  }
  case class KeyVal(key: String, value: Json)
  object KeyVal {
    implicit val kvRead: Read[KeyVal] = Read[(String, String)].map { case (id, body) =>
      KeyVal(id, parse(body).toOption.get)
    } // bad, but fine for a hack
    implicit val kvWrite: Write[KeyVal] =
      Write[(String, String)].contramap(kv => (kv.key, kv.value.asString.get))

  }
}

object DB {
  import Model._
  val xa = Transactor.fromDriverManager[IO](
    "org.sqlite.JDBC",
    "jdbc:sqlite:interview.db",
    "",
    "",
  )
  val y = xa.yolo
  import y._

  def drop = sql"""
    DROP TABLE IF EXISTS points;
    DROP TABLE IF EXISTS keyvals;
    """.update

  def create =
    sql"""
    create table points (
      x INTEGER NOT NULL,
      y INTEGER NOT NULL
    );
    create table keyvals (
      key TEXT NOT NULL UNIQUE,
      val JSON
    );
  """.update.run
  def insertPoint(point: Point) =
    sql"insert into points (x,y) values (${point.x}, ${point.y})".update.quick
      .unsafeRunSync()
  def insertKeyVal(key: String, value: Json) =
    sql"insert into keyval (key,val) values ($key, ${value.asString})".update.quick
      .unsafeRunSync()

  def getPoints() =
    sql"select * from points".query[Point].to[List].transact(xa).unsafeRunSync()
  def getKeyVal(key: String) =
    sql"select * from keyval where key = $key"
      .query[KeyVal]
      .to[List]
      .transact(xa)
      .unsafeRunSync()
  def getKeyVals() =
    sql"select * from keyvals".query[KeyVal].to[List].transact(xa).unsafeRunSync()

}
