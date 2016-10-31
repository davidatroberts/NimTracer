import unittest, ../src/vector

suite "vector suite":

  test "equals":
    let a = newVector(10, 10, 10)
    let b = newVector(10, 10, 10)
    let res = a==b
    check res == true

  test "addition":
      let a = newVector(10, 20, 30)
      let b = newVector(30, 40, 50)
      let res = a+b
      let exp = newVector(40, 60, 80)
      check exp == res
