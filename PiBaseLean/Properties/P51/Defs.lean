module

public import Mathlib.Topology.Defs.Induced
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 51. Scattered -/
class ScatteredSpace (X : Type*) [TopologicalSpace X] : Prop where
  scattered : ∀ Y : Set X, Y.Nonempty → ∃ x : Y, IsOpen {x}

end PiBase

namespace PiBase.Formal

def P51 : Property where
  toPred := ScatteredSpace
  well_defined φ h := sorry

end PiBase.Formal
