import nake
import os

const
  ROOT_TEST_DIR = "tests"

task "default", "Build project":
  echo "did something"

task "build", "Build project":
  echo "did something"

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
