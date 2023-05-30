package backend

import munit.FunSuite

class InterviewSpec extends FunSuite { self =>
  test("some test") {
    println("hello")
    assert(true)
  }
  test("some othertest") {
    assert(false)
  }

}
