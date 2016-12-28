import math

import ray
import vector

type
  Camera* = ref object of RootObj
    origin*, lowerLeftCorner, horizontal, vertical, u, v, w: Vector
    lensRadius: float

proc newCamera*(lookfrom, lookat, vup: Vector, vfov, aspect, aperture, focusDist: float): Camera =
  new(result)
  result.lensRadius = aperture/2.0
  let theta = vfov*PI/180.0
  let halfHeight = tan(theta/2.0)
  let halfWidth = aspect * halfHeight
  result.origin = lookfrom
  result.w = unitDirection(lookfrom-lookat)
  result.u = unitDirection(cross(vup, result.w))
  result.v = cross(result.w, result.u)
  result.lowerLeftCorner = result.origin - halfWidth*focusDist*result.u - halfHeight*focusDist*result.v - focusDist*result.w
  result.horizontal = 2.0*halfWidth*focusDist*result.u
  result.vertical = 2.0*halfHeight*focusDist*result.v

proc getRay*(c: Camera, s, t: float): Ray =
  let rd = c.lensRadius * randomInUnitDisk()
  let offset = c.u * rd.x + c.v * rd.y

  result = newRay(c.origin + offset, c.
    lowerLeftCorner + s*c.horizontal + t*c.vertical - c.origin - offset)
