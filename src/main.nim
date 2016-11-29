import vector
import ray
import outputbuffer

proc colour(r: Ray): Vector =
  let unitDir = unitDirection(r.direction)
  let t = 0.5*(unitDir.y + 1.0)
  result = (1.0-t)*newVector(1.0, 1.0, 1.0) + t*newVector(0.5, 0.7, 1.0)

let nx = 200
let ny = 100

let lowerLeftCorner = newVector(-2.0, -1.0, -1.0)
let vertical = newVector(0.0, 2.0, 0.0)
let horizontal = newVector(4.0, 0.0, 0.0)
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
