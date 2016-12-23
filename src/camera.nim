import ray
import vector

type
  Camera* = ref object of RootObj
    origin*, lowerLeftCorner*, horizontal*, vertical*: Vector


proc newCamera*(o, lLC, h, v: Vector): Camera =
  new(result)
  result.origin = o
  result.lowerLeftCorner = lLC
  result.horizontal = h
  result.vertical = v

proc getRay*(c: Camera, u, v: float): Ray =
  result = newRay(c.origin,
    c.lowerLeftCorner + u*c.horizontal + v*c.vertical - c.origin)
