import ospaths

mode = ScriptMode.Verbose

version = "1.0"
author = "Username"
description = "Build with debug configuration"
license = "MIT"

let qmlDir = "qmlui"
let outDir = "bin/debug"

mkdir(outDir)

proc buildResources (dir: string) =
  for subdir in listDirs(dir):
    buildResources(subdir)
  for subfile in listFiles(dir):
    var (dir, name, ext) = splitFile(subfile)
    if ext == ".qrc":
      exec ("rcc --binary " & subfile & " -o " & joinPath(outDir, name & ".rcc"))

buildResources(qmlDir)

let buildAppCmd = "nim" &
  " " & "cc" &
  " " & "--nimcache:" & joinPath(@[outDir, "nimcache"]) &
  " " & "--out:" & joinPath(@[outDir, "main"]) &
  " " & "-d:debug" &
  " " & "--debuginfo" &
  " " & "--lineDir:on" &
  " " & "--debugger:native" &
  " " & "src/main.nim"

exec buildAppCmd