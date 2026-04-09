module

public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 171. k₂-Hausdorff -/
class K2T2Space (X : Type u) [TopologicalSpace X] : Prop where
  closed_continuous : ∀ ⦃K : Type u⦄ {_ : TopologicalSpace K} (f : K → X × X),
    T2Space K → CompactSpace K → Continuous f → IsClosed (f ⁻¹' (diagonal X))

end PiBase

namespace PiBase.Formal

def P171 : Property where
  toPred := K2T2Space
  well_defined φ h := sorry

end PiBase.Formal
