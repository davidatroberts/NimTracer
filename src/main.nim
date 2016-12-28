import math
import random
import strutils

import camera
import hitable
import hitrecord
import material
import ray
import outputbuffer
import vector

proc colour(r: Ray, world: HitableList, depth: int): Vector =
  var hr: HitRecord
  if world.hit(r, 0.001, Inf, hr):
    var scattered: Ray
    var attenuation: Vector

    if depth < 50 and hr.material.scatter(r, hr, attenuation, scattered):
      result = attenuation * colour(scattered, world, depth+1)
    else:
      result = newVector(0, 0, 0)
  else:
    let unitDir = unitDirection(r.direction)
    let t = 0.5*(unitDir.y + 1.0)
    result = (1.0-t)*newVector(1.0, 1.0, 1.0) + t*newVector(0.5, 0.7, 1.0)

randomize()

# image settings
let nx = 400
let ny = 200
let ns = 50
var fb = newOutputBuffer(Natural(nx), Natural(ny))

# camera setup
let lowerLeftCorner = newVector(-2.0, -1.0, -1.0)
let horizontal = newVector(4.0, 0.0, 0.0)
let vertical = newVector(0.0, 2.0, 0.0)
let origin = newVector(0.0, 0.0, 0.0)
let cam = newCamera(origin, lowerLeftCorner, horizontal, vertical)

# world setup
var things: seq[Hitable] = @[
  Hitable(newSphere(newVector(0.0, 0.0, -1.0), 0.5,
    newLambertian(newVector(0.1, 0.2, 0.5)))),
  Hitable(newSphere(newVector(0.0, -100.5, -1.0), 100.0,
    newLambertian(newVector(0.8, 0.8, 0.0)))),
  Hitable(newSphere(newVector(1.0, 0.0, -1.0), 0.5,
    newMetal(newVector(0.8, 0.6, 0.2), 0.3))),
  Hitable(newSphere(newVector(-1.0, 0.0, -1.0), 0.5,
    newDielectric(1.5))),
  Hitable(newSphere(newVector(-1, 0, -1), -0.45,
    newDielectric(1.5)))
]

let world = newHitableList(things)

for j in countdown(ny-1, 0):
  for i in countup(0, nx-1):
    var col = newVector(0, 0, 0)

    for s in countup(0, ns-1):
      let u = float(float(i)+random(1.0))/float(nx)
      let v  =float(float(j)+random(1.0))/float(ny)
      let r = cam.getRay(u, v)
      col += colour(r, world, 0)

    col /= float(ns)
    col = newVector(sqrt(col.x), sqrt(col.y), sqrt(col.z))
    fb.put(Natural(i), Natural(j), col)

fb.toFile("img.ppm")
