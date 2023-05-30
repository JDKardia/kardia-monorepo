package backend.database

import backend.model.Document
import cats.data.Validated
import cats.effect.IO
import cats.effect.unsafe.implicits.global
import cats.implicits.toTraverseOps
import cats.syntax.either._
import doobie.implicits.{
  toConnectionIOOps,
  toDoobieApplicativeErrorOps,
  toSqlInterpolator,
}
import doobie.{ LogHandler, Transactor }
import org.log4s.getLogger

import java.sql.SQLException
import java.time.OffsetDateTime

class PackageDao(xa: Transactor[IO]) {
  val logger       = getLogger
  implicit val han = LogHandler.jdkLogHandler

  def upsert(id: String, body: String): IO[Either[SQLException, Int]] = {
    val now = OffsetDateTime.now().toString
    sql"""
      |INSERT INTO documents(id, body, modified_at)
      |VALUES (
      |    $id,
      |    $body,
      |    $now
      |) ON CONFLICT(id) DO UPDATE SET
      |    body=excluded.body,
      |    modified_at=excluded.modified_at
      |WHERE excluded.modified_at>documents.modified_at""".stripMargin.update.run.attemptSql
      .transact(xa)
  }

  def searchWithId(id: String): IO[Either[SQLException, List[Document]]] = sql"""
    |SELECT * FROM documents
    |WHERE id = $id
    |LIMIT 1""".stripMargin.query[Document].to[List].attemptSql.transact(xa)

  def delete(id: String): IO[Either[SQLException, Int]] = sql"""
    |DELETE FROM documents
    |WHERE id=$id """.stripMargin.update.run.attemptSql.transact(xa)

  def createDocumentsTable: IO[Boolean] = sql"""
    |CREATE TABLE IF NOT EXISTS documents (
    |  id text UNIQUE PRIMARY KEY,
    |  body text,
    |  modified_at Text
    |) """.stripMargin.update.run.attemptSql.transact(xa).map {
    case Right(_) => logger.info("bootstrapped"); true
    case Left(e)  => logger.error(e)("failed to bootstrap"); false
  }

  def resetDocumentsTable: IO[Validated[List[SQLException], List[Int]]] = List(
    sql"DROP TABLE IF EXISTS documents",
    sql"""
    |CREATE TABLE IF NOT EXISTS documents (
    |  id text UNIQUE PRIMARY KEY,
    |  body text,
    |  modified_at Text
    |) """.stripMargin,
  ).traverse(_.update.run.attemptSql)
    .transact(xa)
    .map(results => results.traverse(r => r.toValidated.bimap(List(_), identity)))

  createDocumentsTable.unsafeRunSync()
}
