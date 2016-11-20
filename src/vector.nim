import math

const epsilon = 0.00001

type
  Vector* = ref object of RootObj
    x*, y*, z*: float32

proc newVector*(x, y, z: float32): Vector =
  new(result)
  result.x = x
  result.y = y
  result.z = z

proc p_norm*(v: Vector, p: float32): float32 =
  let xx = pow(v.x, p)
  let yy = pow(v.y, p)
  let zz = pow(v.z, p)

  let sqr = xx+yy+zz
  result = pow(sqr, 1.0/p)

proc magnitude*(v: Vector): float32 =
  result = v.p_norm(2)

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

proc `*`*(v: Vector, s: float32): Vector =
  result = newVector(v.x*s, v.y*s, v.z*s)

proc `*=`*(v: var Vector, s: float32) =
  v.x *= s
  v.y *= s
  v.z *= s

proc `/`*(v: Vector, s: float32): Vector =
  result = newVector(v.x/s, v.y/s, v.z/s)

proc `/=`*(v: var Vector, s: float32) =
  v.x /= s
  v.y /= s
  v.z /= s

proc `$`*(v: Vector): string =
  result = "[" & $v.x & "," & $v.y & "," & $v.z & "]"

proc normalize*(v: var Vector) =
  let m = v.magnitude()
  v*=(1.0/m)

proc approx*(a, b: Vector): bool =
  (abs(a.x - b.x) < epsilon) and (abs(a.y - b.y) < epsilon) and (abs(a.z - b.z) < epsilon)

proc dot*(a, b: Vector): float32 =
  result = a.x*b.x + a.y*b.y + a.z*b.z

proc cross*(a, b: Vector): Vector =
  let xx = a.y*b.z - a.z*b.y
  let yy = a.z*b.x - a.x*b.z
  let zz = a.x*b.y - a.y*b.x
  result = newVector(xx, yy, zz)
