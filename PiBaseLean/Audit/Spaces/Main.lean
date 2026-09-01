module

public import Lean
public meta import PiBaseLean.Spaces

open Lean
open PiBase.Audit.Spaces

public meta def runAudit (env : Environment) : IO UInt32 := do
  let context : Core.Context := {
    fileName := "<spaceAudit>"
    fileMap := default
  }
  let state : Core.State := { env }
  let (report, _) ← Lean.Core.CoreM.toIO (Meta.MetaM.run' buildAuditReport) context state
  IO.println report.toJsonString
  return if report.isSuccess then 0 else 1

public unsafe def main : IO UInt32 := do
  initSearchPath (← findSysroot)
  Lean.enableInitializersExecution
  let env ← importModules
    #[{ module := `PiBaseLean.Audit.Spaces.Main }] {} (loadExts := true)
  let runner ← IO.ofExcept <|
    env.evalConst (Environment → IO UInt32) {} `runAudit
  runner env
