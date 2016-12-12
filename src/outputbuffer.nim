import vector
import strutils

type
  OutputBuffer* = ref object
    width, height: Natural
    buffer: seq[Vector]

proc newOutputBuffer*(width, height: Natural): OutputBuffer =
  new(result)
  result.width = width
  result.height = height
  result.buffer = newSeq[Vector](width*height)

proc put*(op: var OutputBuffer, x, y: Natural, colour: Vector) =
  op.buffer[x*op.height+y] = colour

proc toFile*(op: OutputBuffer, path: string) =
  var f: File
  if open(f, path, fmWrite):
    write(f, "P3\n")
    write(f, "$1 $2\n"%[$op.width, $op.height])
    write(f, "$1\n"%[$255])

    for y in countdown(op.height-1, 0):
      for x in countup(0, op.width-1):
        write(f, "$1 $2 $3 "%[
          $op.buffer[x*op.height+y].rq,
          $op.buffer[x*op.height+y].gq,
          $op.buffer[x*op.height+y].bq]
        )
      write(f, "\n")

    close(f)
