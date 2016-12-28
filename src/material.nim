import random

import hitrecord
import mathutil
import ray
import vector

type
  Lambertian* = ref object of Material
    albedo: Vector
  Metal* = ref object of Material
    albedo: Vector
    fuzz: float
  Dielectric* = ref object of Material
    ri: float

method scatter*(mat: Material, rayIn: Ray, rec: HitRecord, attenuation: var Vector, scattered: var Ray): bool {.base.} =
  return false

proc newLambertian*(albedo: Vector): Lambertian =
  new(result)
  result.albedo = albedo

method scatter*(lamb: Lambertian, rayIn: Ray, rec: HitRecord, attenuation: var Vector, scattered: var Ray): bool =
  let target = rec.p + rec.normal + randomInUnitSphere()
  scattered = newRay(rec.p, target-rec.p)
  attenuation = lamb.albedo
  result = true

proc newMetal*(albedo: Vector, fuzz: float): Metal =
  new(result)
  result.albedo = albedo

  if fuzz < 1:
    result.fuzz = fuzz
  else:
    result.fuzz = 1

method scatter*(metal: Metal, rayIn: Ray, rec: HitRecord, attenuation: var Vector, scattered: var Ray): bool =
  let reflected = reflect(rayIn.direction.unitDirection(), rec.normal)
  scattered = newRay(rec.p, reflected+metal.fuzz*randomInUnitSphere())
  attenuation = metal.albedo
  result = dot(scattered.direction, rec.normal) > 0

proc newDielectric*(ri: float): Dielectric =
  new(result)
  result.ri = ri

method scatter*(dielectric: Dielectric, rayIn: Ray, rec: HitRecord, attenuation: var Vector, scattered: var Ray): bool =
  var outwardNormal: Vector
  let reflected = reflect(rayIn.direction, rec.normal)
  var niOverNt: float
  attenuation = newVector(1.0, 1.0, 1.0)
  var refracted: Vector
  var reflectProb, cosine: float

  if dot(rayIn.direction, rec.normal) > 0:
    outwardNormal = -rec.normal
    niOverNt = dielectric.ri
    cosine = (dielectric.ri*dot(rayIn.direction, rec.normal)/rayIn.direction.magnitude())
  else:
    outwardNormal = rec.normal
    niOverNt = 1.0/dielectric.ri
    cosine = -dot(rayIn.direction, rec.normal)/rayIn.direction.magnitude()

  if refract(rayIn.direction, outwardNormal, niOverNt, refracted):
    reflectProb = schlick(cosine, dielectric.ri)
  else:
    scattered = newRay(rec.p, reflected)
    reflectProb = 1.0

  if random(1.0) < reflectProb:
    scattered = newRay(rec.p, reflected)
  else:
    scattered = newRay(rec.p, refracted)

  return true
