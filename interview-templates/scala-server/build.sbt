val http4sVersion          = "0.23.11"
val circeVersion           = "0.14.1"
val munitVersion           = "0.7.29"
val logbackVersion         = "1.2.10"
val munitCatsEffectVersion = "1.0.7"
val doobieVersion          = "1.0.0-RC2"
val sqliteVersion          = "3.36.0.3"
val pureConfigVersion      = "0.17.1"

lazy val root = (project in file("."))
  .settings(
    name         := "backend",
    version      := "0.0.1-SNAPSHOT",
    scalaVersion := "2.13.8",
    libraryDependencies ++= Seq(
      "ch.qos.logback" % "logback-classic"     % logbackVersion         % Runtime,
      "io.circe"      %% "circe-core"          % circeVersion,
      "io.circe"      %% "circe-parser"        % circeVersion,
      "io.circe"      %% "circe-generic"       % circeVersion,
      "org.http4s"    %% "http4s-circe"        % http4sVersion,
      "org.http4s"    %% "http4s-core"         % http4sVersion,
      "org.http4s"    %% "http4s-dsl"          % http4sVersion,
      "org.http4s"    %% "http4s-ember-client" % http4sVersion,
      "org.http4s"    %% "http4s-ember-server" % http4sVersion,
      "org.tpolecat"  %% "doobie-core"         % doobieVersion,
      "org.tpolecat"  %% "doobie-hikari"       % doobieVersion,
      "org.scalameta" %% "munit"               % munitVersion           % Test,
      "org.tpolecat"  %% "doobie-munit"        % doobieVersion          % Test,
      "org.typelevel" %% "munit-cats-effect-3" % munitCatsEffectVersion % Test,
      "org.xerial"     % "sqlite-jdbc"         % sqliteVersion,
      "com.github.pureconfig" %% "pureconfig" % pureConfigVersion,
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
