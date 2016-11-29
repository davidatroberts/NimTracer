import vector

type
  Ray* = ref object of RootObj
    origin*, direction*: Vector

proc newRay*(origin, direction: Vector): Ray =
  new(result)
  result.origin = origin
  result.direction = direction

proc pAtParamater*(r: Ray, t: float32): Vector =
  result = r.origin + (r.direction*t)
