import nake
import os

const
  ROOT_TEST_DIR = "tests"
  SRC_DIR       = "src"
  BIN_DIR       = "bin"

task "default", "Build project":
  echo "did something"

task "build", "Build project":
  withDir(SRC_DIR):
    createDir(".." / BIN_DIR)
    shell("nim", "c", "--verbosity:0", "-o:../bin/rt", "main.nim")


task "debug", "Build project in debug mode":
  echo "did something"

task "run", "Build and install project":
  echo "did something"

task "test", "Run the tests":
  for kind, testfile in walkDir(ROOT_TEST_DIR):
    if not testfile.endsWith("_test.nim"):
      continue

    shell("nim", "c", "--verbosity:0", "-r", testfile)

task "list", "Lists all of the commands":
  listTasks()
