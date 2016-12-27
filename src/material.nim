import hitrecord
import ray
import vector

type
  Lambertian* = ref object of Material
    albedo: Vector
  Metal* = ref object of Material
    albedo: Vector
    fuzz: float

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
