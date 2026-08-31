module

public import Lean

@[expose] public meta section

namespace PiBase.Audit.Meta

open Lean

/-- Collect the transitive axioms used by a declaration after checking that it exists. -/
def collectAxioms (declName : Name) : CoreM (Array Name) := do
  discard <| getConstInfo declName
  Lean.collectAxioms declName

/-- Test definitional equality, allowing unification of fresh elaboration metavariables. -/
def isDefEq (lhs rhs : Expr) : MetaM Bool :=
  Lean.Meta.isDefEq lhs rhs

/-- Require definitional equality and report both elaborated expressions on failure. -/
def assertDefEq (description : String) (actual expected : Expr) : MetaM Unit := do
  unless ← isDefEq actual expected do
    let actual ← Lean.Meta.whnf actual
    let expected ← Lean.Meta.whnf expected
    throwError "{description}\nactual:   {actual}\nexpected: {expected}"

/-- Require a declaration to be kernel-checked rather than `unsafe` or `partial`. -/
def assertKernelChecked (description : String) (declName : Name) : MetaM Unit := do
  let env ← getEnv
  let info ← getConstInfo declName
  if info.isUnsafe then
    throwError "{description} {declName} is unsafe"
  let partialWrapper := match info with
    | .opaqueInfo _ =>
        (env.find? (Name.mkStr declName "_unsafe_rec")).any (·.isPartial)
    | _ => false
  if info.isPartial || partialWrapper then
    throwError "{description} {declName} is partial"

end PiBase.Audit.Meta
