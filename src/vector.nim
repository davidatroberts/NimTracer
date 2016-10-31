type
  Vector* = ref object of RootObj
    x*, y*, z*: float32

proc newVector*(x, y, z: float32): Vector =
  new(result)
  result.x = x
  result.y = y
  result.z = z

proc `+`*(a, b: Vector): Vector =
  result = newVector(a.x+b.x, a.y+b.y, a.z+b.z)

proc `==`*(a, b: Vector): bool =
  result = (a.x == b.x) and (a.y == b.y) and (a.z == b.z)
