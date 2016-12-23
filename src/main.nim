import strutils
import math

import vector
import ray
import outputbuffer

proc hitSphere(centre: Vector, radius: float, ray: Ray): float =
  let oc = ray.origin - centre
  let a = dot(ray.direction, ray.direction)
  let b = 2.0 * dot(oc, ray.direction)
  let c = dot(oc, oc) - radius*radius
  let discriminant = b*b - 4*a*c

  if discriminant < 0:
    return -1.0
  else:
    return (-b-sqrt(discriminant)) / (2.0*a)


proc colour(r: Ray): Vector =
  let t = hitSphere(newVector(0.0, 0.0, -1.0), 0.5, r)
  if t > 0.0:
    let n = unitDirection(r.pAtParamater(t) - newVector(0.0, 0.0, -1.0))
    return 0.5*newVector(n.x+1, n.y+1, n.z+1)

  let unitDir = unitDirection(r.direction)
  let tt = 0.5*(unitDir.y + 1.0)
  result = (1.0-tt)*newVector(1.0, 1.0, 1.0) + tt*newVector(0.5, 0.7, 1.0)

let nx = 200
let ny = 100

let lowerLeftCorner = newVector(-2.0, -1.0, -1.0)
let horizontal = newVector(4.0, 0.0, 0.0)
let vertical = newVector(0.0, 2.0, 0.0)
let origin = newVector(0.0, 0.0, 0.0)

var fb = newOutputBuffer(Natural(nx), Natural(ny))

for j in countdown(ny-1, 0):
  for i in countup(0, nx-1):
    let u = float(i)/float(nx)
    let v = float(j)/float(ny)

    let r = newRay(origin, lowerLeftCorner + u*horizontal + v*vertical)
    let col = colour(r)

    fb.put(Natural(i), Natural(j), col)

fb.toFile("img.ppm")
