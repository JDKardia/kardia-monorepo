package xyz.kardia.scala

import munit.FunSuite

class DBConnSpec extends FunSuite { self =>
  test("some test") {
    println("hello")
    assert(true)
  }
  test("some othertest") {
    assert(false)
  }

}
