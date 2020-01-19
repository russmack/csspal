#[
  Reads a css file, extracts the colours, 
  and outputs a html palette.
]#

import os
import re
import algorithm
import sequtils
import strutils

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
    elems.add("<div>" & 
      "<span style='background-color: " & col & "; width: 30px; height: 20px; display: inline-block;'></span>&nbsp;" &
      "<span style='font-family: Helvetica,sans-serif;'>" & col & "</span>" & 
      "</div>\n")
  return elems

proc makePageHeader(cssFileName: string): seq[string] =
  var elems: seq[string]
  elems.add("<div style='font-family: Helvetica, sans-serif'>Web Colour Palette</div>")  # Title
  elems.add("<div style='font-family: Helvetica, sans-serif'>Extracted from file: " & cssFileName & "</div>")  # Subtitle
  elems.add("<hr style='border-top: 1px;' />")  # Header break
  return elems

proc extractColours(text: string): seq[string] =
  var colours: seq[string]
  let lines = text.splitLines()
  for line in lines:
    let matches = findAll(line, re"(#[0-9a-fA-F]{3}\b)|(#[0-9a-fA-F]{6}\b)")
    colours.add(matches)
  return colours

proc orderColours(colours: seq[string]): seq[string] =
  var colours = colours
  sort(colours, system.cmp)
  colours = deduplicate(colours, isSorted = true)
  return colours

proc readArg(): string =
  if paramCount() != 1:
    echo "Usage: main my.css"
    quit(QuitFailure)
  let arg = paramStr(1)
  return arg

proc main() =
  let cssFileName = readArg()
  let text = readFile(cssFileName)
  var colours = extractColours(text)
  colours = orderColours(colours)
  let colourElems = makeColourElems(colours)
  let pageHeader = makePageHeader(cssFileName)
  let pageElems = pageHeader & colourElems
  echo (
    html(
      head(),
      body(pageElems)
    )
  )

main()

