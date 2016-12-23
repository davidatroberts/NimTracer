import math
import strutils

import camera
import hitable
import random
import ray
import outputbuffer
import vector

proc colour(r: Ray, world: HitableList): Vector =
  var hr: HitRecord
  if world.hit(r, 0.0, Inf, hr):
    result = 0.5*newVector(hr.normal.x+1, hr.normal.y+1, hr.normal.z+1)
  else:
    let unitDir = unitDirection(r.direction)
    let t = 0.5*(unitDir.y + 1.0)
    result = (1.0-t)*newVector(1.0, 1.0, 1.0) + t*newVector(0.5, 0.7, 1.0)

randomize()

# image settings
let nx = 400
let ny = 200
let ns = 100
var fb = newOutputBuffer(Natural(nx), Natural(ny))

# camera setup
let lowerLeftCorner = newVector(-2.0, -1.0, -1.0)
let horizontal = newVector(4.0, 0.0, 0.0)
let vertical = newVector(0.0, 2.0, 0.0)
let origin = newVector(0.0, 0.0, 0.0)
let cam = newCamera(origin, lowerLeftCorner, horizontal, vertical)

# world setup
var things: seq[Hitable] = @[
  Hitable(newSphere(newVector(0.0, 0.0, -1.0), 0.5)),
  Hitable(newSphere(newVector(0.0, -100.5, -1.0), 100.0))]

let world = newHitableList(things)

for j in countdown(ny-1, 0):
  for i in countup(0, nx-1):
    var col = newVector(0, 0, 0)

    for s in countup(0, ns-1):
      let u = float(float(i)+random(1.0))/float(nx)
      let v  =float(float(j)+random(1.0))/float(ny)
      let r = cam.getRay(u, v)
      col += colour(r, world)

    col /= float(ns)
    fb.put(Natural(i), Natural(j), col)

fb.toFile("img.ppm")
