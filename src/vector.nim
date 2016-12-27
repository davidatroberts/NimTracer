import math
import random

const epsilon = 0.00001

type
  Vector* = ref object of RootObj
    x*, y*, z*: float

proc newVector*(x, y, z: float): Vector =
  new(result)
  result.x = x
  result.y = y
  result.z = z

proc p_norm*(v: Vector, p: float): float =
  let xx = pow(v.x, p)
  let yy = pow(v.y, p)
  let zz = pow(v.z, p)

  let sqr = xx+yy+zz
  result = pow(sqr, 1.0/p)

proc magnitude*(v: Vector): float =
  result = v.p_norm(2)

proc squaredLength*(v: Vector): float =
  result = v.x*v.x + v.y*v.y + v.z*v.z

proc `+`*(a, b: Vector): Vector =
  result = newVector(a.x+b.x, a.y+b.y, a.z+b.z)

proc `+=`*(v: var Vector, other: Vector) =
  v.x += other.x
  v.y += other.y
  v.z += other.z

proc `-`*(a, b: Vector): Vector =
  result = newVector(a.x-b.x, a.y-b.y, a.z-b.z)

proc `-=`*(v: var Vector, other: Vector) =
  v.x -= other.x
  v.y -= other.y
  v.z -= other.z

proc `==`*(a, b: Vector): bool =
  result = (a.x == b.x) and (a.y == b.y) and (a.z == b.z)

proc `*`*(v: Vector, s: float): Vector =
  result = newVector(v.x*s, v.y*s, v.z*s)

proc `*`*(s: float, v: Vector): Vector =
  result = v*s

proc `*`*(a, b: Vector): Vector =
  result = newVector(a.x*b.x, a.y*b.y, a.z*b.z)

proc `*=`*(v: var Vector, s: float) =
  v.x *= s
  v.y *= s
  v.z *= s

proc `/`*(v: Vector, s: float): Vector =
  result = newVector(v.x/s, v.y/s, v.z/s)

proc `/=`*(v: var Vector, s: float) =
  v.x /= s
  v.y /= s
  v.z /= s

proc `$`*(v: Vector): string =
  result = "[" & $v.x & "," & $v.y & "," & $v.z & "]"

proc normalize*(v: var Vector) =
  let m = v.magnitude()
  v*=(1.0/m)

proc unitDirection*(v: Vector): Vector =
  let m = v.magnitude()
  result = v*(1.0/m)

proc approx*(a, b: Vector): bool =
  (abs(a.x - b.x) < epsilon) and (abs(a.y - b.y) < epsilon) and (abs(a.z - b.z) < epsilon)

proc dot*(a, b: Vector): float =
  result = a.x*b.x + a.y*b.y + a.z*b.z

proc cross*(a, b: Vector): Vector =
  let xx = a.y*b.z - a.z*b.y
  let yy = a.z*b.x - a.x*b.z
  let zz = a.x*b.y - a.y*b.x
  result = newVector(xx, yy, zz)

proc r*(v: Vector): float =
  result = v.x

proc g*(v: Vector): float =
  result = v.y

proc b*(v: Vector): float =
  result = v.z

proc rq*(v: Vector): uint8 =
  result = uint8(min(255.0, (v.x*256.0)))

proc gq*(v: Vector): uint8 =
  result = uint8(min(255.0, (v.y*256.0)))

proc bq*(v: Vector): uint8 =
  result = uint8(min(255.0, (v.z*256.0)))

proc randomInUnitSphere*(): Vector =
  var p: Vector
  p = 2.0*newVector(random(1.0), random(1.0), random(1.0)) - newVector(1, 1, 1)

  while p.squaredLength() >= 1.0:
    p = 2.0*newVector(random(1.0), random(1.0), random(1.0)) - newVector(1, 1, 1)

  result = p

proc reflect*(v: Vector, n: Vector): Vector =
  result = v - 2.0*dot(v, n)*n
