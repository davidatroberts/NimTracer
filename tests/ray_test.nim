import unittest, ../src/vector, ../src/ray

suite "ray suite":

  test "pointAlongRay":
    let o = newVector(0, 0, 0)
    let d = newVector(0, 1, 2)
    let r = newRay(o, d)

    var t = 1.0
    var res = r.pAtParamater(t)
    var exp = newVector(0, 1, 2)
    check exp == res

    t = 0.5
    res = r.pAtParamater(t)
    exp = newVector(0, 0.5, 1)
    check exp == res
