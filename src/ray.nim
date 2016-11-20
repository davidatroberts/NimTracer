import vector

type
  Ray* = ref object of RootObj
    a*, b*: Vector

proc newRay*(a, b: Vector): Ray =
  new(result)
  result.a = a
  result.b = b

proc pAtParamater*(r: Ray, t: float32): Vector =
  result = r.a + (r.b*t)
