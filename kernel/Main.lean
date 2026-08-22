/-
The vps executable: the proved gate, compiled. The binary that runs in the
pre-commit hook and in CI is the same artifact the theorems are about.
-/
import Vps
import Lean.Data.Json

open Lean (Json)

def parseFacts (s : String) : Except String Vps.Facts := do
  let j ← Json.parse s
  let pathsJson ← (← j.getObjVal? "paths_changed").getArr?
  let paths ← pathsJson.mapM (·.getStr?)
  let records ← (← j.getObjVal? "records_added").getNat?
  return { pathsChanged := paths.toList, recordsAdded := records }

def citeStr (c : Vps.Citation) : String :=
  s!"[{c.year}] VPS {c.ordinal}"

def main (args : List String) : IO UInt32 := do
  match args with
  | ["validate", path] =>
    let s ← IO.FS.readFile path
    match parseFacts s with
    | .error e =>
      IO.eprintln s!"vps: unreadable facts ({e}); the gate fails closed"
      return 2
    | .ok f =>
      match Vps.gate f with
      | .allow =>
        IO.println "ALLOW"
        return 0
      | .deny cs =>
        IO.println "DENY — the following instruments forbid this change:"
        for c in cs do
          IO.println s!"  {citeStr c}"
        return 1
  | ["book"] =>
    IO.println s!"The statute book holds {Vps.theBook.length} instruments."
    IO.println "Its legitimacy is a compile-time theorem (Vps.book_lawful):"
    IO.println "if this binary exists, the book is lawful."
    for i in Vps.theBook do
      IO.println s!"  {citeStr i.cite}"
    return 0
  | _ =>
    IO.eprintln "usage: vps validate <facts.json> | vps book"
    return 2
