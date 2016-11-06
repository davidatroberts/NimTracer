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

  test "additionInPlace":
    var a = newVector(10, 20, 30)
    let b = newVector(30, 40, 50)
    a+=b
    let exp = newVector(40, 60, 80)
    check exp == a

  test "subtraction":
    let a = newVector(10, 40, 87)
    let b = newVector(30, 20, 50)
    let res = a-b
    let exp = newVector(-20, 20, 37)
    check exp == res

  test "subtractionInPlace":
    var a = newVector(10, 40, 87)
    let b = newVector(30, 20, 50)
    a-=b
    let exp = newVector(-20, 20, 37)
    check exp == a

  test "multScalar":
    let a = newVector(10, 20, 30)
    let res = a*8
    let exp = newVector(80, 160, 240)
    check exp == res

  test "divScalar":
    let a = newVector(10, 20, 30)
    let res = a/5
    let exp = newVector(2, 4, 6)
    check exp == res

  test "magnitude":
    let a = newVector(5, 10, 10)
    let res = a.magnitude()
    let exp = 15
    check exp == res
