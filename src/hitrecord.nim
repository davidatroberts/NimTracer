import vector

type
  Material* = ref object of RootObj
  HitRecord* = tuple[t: float, p: Vector, normal: Vector, material: Material]
