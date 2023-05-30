val Http4sVersion          = "0.23.11"
val CirceVersion           = "0.14.1"
val MunitVersion           = "0.7.29"
val LogbackVersion         = "1.2.10"
val MunitCatsEffectVersion = "1.0.7"
val sqliteJDBCVersion      = "3.23.1"
val doobieVersion          = "1.0.0-RC2"

lazy val root = (project in file("."))
  .settings(
    organization := "interview",
    name         := "scala-backend",
    version      := "0.0.1-SNAPSHOT",
    scalaVersion := "2.13.8",
    libraryDependencies ++= Seq(
      "io.circe"      %% "circe-core"    % CirceVersion,
      "io.circe"      %% "circe-generic" % CirceVersion,
      "io.circe"      %% "circe-parser"  % CirceVersion,
      "org.xerial"     % "sqlite-jdbc"   % sqliteJDBCVersion,
      "org.tpolecat"  %% "doobie-core"   % doobieVersion,
      "org.tpolecat"  %% "doobie-hikari" % doobieVersion,
      "org.scalameta" %% "munit"         % MunitVersion  % Test,
      "org.tpolecat"  %% "doobie-munit"  % doobieVersion % Test,
      "com.lihaoyi"   %% "pprint"        % "0.7.0",
    ),
    addCompilerPlugin(
      "org.typelevel" %% "kind-projector" % "0.13.2" cross CrossVersion.full,
    ),
    addCompilerPlugin("com.olegpy" %% "better-monadic-for" % "0.3.1"),
    testFrameworks += new TestFramework("munit.Framework"),
  )
tpolecatCiModeOptions ~= { opts =>
  opts.filterNot(
    ScalacOptions.privateWarnUnusedOptions ++
      ScalacOptions.warnUnusedOptions,
  )
}
