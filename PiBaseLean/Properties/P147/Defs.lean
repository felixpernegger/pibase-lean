module

public import Mathlib.Data.Countable.Defs
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.GDelta.Basic

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 147. P-space -/
class PSpace (X : Type u) [TopologicalSpace X] : Prop where
  isGδ_open : ∀ ⦃s : Set X⦄, IsGδ s → IsOpen s

end PiBase

namespace PiBase.Formal

def P147 : Property where
  toPred := PSpace
  well_defined φ h := sorry

end PiBase.Formal
