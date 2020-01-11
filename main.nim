#[
  Reads a css file, extracts the colours, 
  and outputs a html palette.
]#

import os
import strutils
import re

proc html(elems: varargs[string]): string =
  var a: string = "<html>\n" 
  for el in elems:
    add(a, el)
  var b: string = "</html>"
  add(a, b)
  return a

proc head(elems: varargs[string]): string =
  var a: string = "<head>\n"
  for el in elems:
    add(a, el)
  add(a, "</head>\n")
  return a

proc body(elems: varargs[string]): string =
  var a: string = "<body>\n"
  for el in elems:
    add(a, el)
  add(a, "</body>\n")
  return a

proc makeColourElems(colours: seq[string]): seq[string] =
  var elems: seq[string]
  for col in colours:
    elems.add("<div style='background-color: " & col & ";'>" & col & "</div>\n")
  return elems

proc extractColours(text: string): seq[string] =
  var colours: seq[string]
  let lines = text.splitLines()
  for line in lines:
    let matches = findAll(line, re"(#[0-9a-fA-F]{3}\b)|(#[0-9a-fA-F]{6}\b)")
    colours.add(matches)
  return colours

proc readArg(): string =
  if paramCount() != 1:
    echo "Usage: main my.css"
    quit(QuitFailure)
  let arg = paramStr(1)
  return arg

proc main() =
  let cssFile = readArg()
  let text = readFile(cssFile)
  let colours = extractColours(text)
  let colour_elems = makeColourElems(colours)
  echo (
    html(
      head(), 
      body(colourElems)
    )
  )

main()

