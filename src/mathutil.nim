import math

proc schlick*(cosine, refIdex: float): float =
  var r0 = (1.0-refIdex) / (1.0+refIdex)
  r0 = r0*r0
  result = r0 + (1.0-r0)*pow((1.0-cosine), 5.0)
  
