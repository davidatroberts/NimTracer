import math

import hitrecord
import material
import ray
import vector

type
  Hitable* = ref object of RootObj
  Sphere* = ref object of Hitable
    centre: Vector
    radius: float
    material: Material
  HitableList* = ref object of Hitable
    list: seq[Hitable]

method hit*(h: Hitable, r: Ray, tmin, tmax: float, rec: var HitRecord): bool {.base.} =
  return false

proc newSphere*(centre: Vector, radius: float, material: Material): Sphere =
  new(result)
  result.centre = centre
  result.radius = radius
  result.material = material

method hit*(s: Sphere, r: Ray, tmin, tmax: float, rec: var HitRecord): bool =
  let oc = r.origin - s.centre
  let a = dot(r.direction, r.direction)
  let b = dot(oc, r.direction)
  let c = dot(oc, oc) - s.radius*s.radius
  let discriminant = b*b - a*c

  if discriminant > 0:
    var temp = (-b-sqrt(b*b - a*c)) / a
    if temp < tmax and temp > tmin:
      rec.t = temp
      rec.p = r.pAtParamater(rec.t)
      rec.normal = (rec.p - s.centre) / s.radius
      rec.material = s.material
      return true

    temp = (-b + sqrt(b*b - a*c)) / a
    if temp < tmax and temp > tmin:
      rec.t = temp
      rec.p = r.pAtParamater(rec.t)
      rec.normal = (rec.p - s.centre) / s.radius
      rec.material = s.material
      return true

  return false

proc newHitableList*(list: seq[Hitable]): HitableList =
  new(result)
  result.list = list

method hit*(h: HitableList, r: Ray, tmin, tmax: float, rec: var HitRecord): bool =
  var tmp: HitRecord
  var hit = false
  var closest = tmax

  for it in h.list:
    if it.hit(r, tmin, closest, tmp):
      hit = true
      closest = tmp.t
      rec = tmp

  result = hit
