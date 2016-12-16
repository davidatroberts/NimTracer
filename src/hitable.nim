import math

import ray
import vector

type
  HitRecord* = tuple[t: float, p: Vector, normal: Vector]
  Hitable* = ref object of RootObj
  Sphere* = ref object of Hitable
    centre: Vector
    radius: float

method hit*(h: Hitable, r: Ray, tmin, tmax: float, rec: var HitRecord): bool {.base.} =
  return false

method hit*(s: Sphere, r: Ray, tmin, tmax: float, rec: var HitRecord): bool =
  let oc = r.origin - s.centre
  let a = dot(r.direction, r.direction)
  let b = 2.0 * dot(oc, r.direction)
  let c = dot(oc, oc) - s.radius*s.radius
  let discriminant = b*b - a*c

  if discriminant > 0:
    var temp = (-b-sqrt(discriminant)) / a
    if temp < tmax and temp > tmin:
      rec.t = temp
      rec.p = r.pAtParamater(rec.t)
      rec.normal = (rec.p - s.centre) / s.radius
      return true
    temp = (-b + sqrt(b*b-a*c)) / a
    if temp < tmax and temp > tmin:
      rec.t = temp
      rec.p = r.pAtParamater(rec.t)
      rec.normal = (rec.p - s.centre) / s.radius
      return true
  return false


proc newSphere(centre: Vector, radius: float): Sphere =
  new(result)
  result.centre = centre
  result.radius = radius
