module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace
public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 141. k₂-space -/
class K2Space (X : Type u) [TopologicalSpace X] : Prop where
  isCoherentWith : IsCoherentWith {s : Set X | ∀ (Y : Type u) (_ : TopologicalSpace Y) (f : Y → X),
    CompactSpace Y → T2Space Y → Continuous f → IsOpen (f ⁻¹' s)}

end PiBase

namespace PiBase.Formal

def P141 : Property where
  toPred := K2Space
  well_defined φ h := sorry

end PiBase.Formal
