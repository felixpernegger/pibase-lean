module

public import Mathlib.Topology.Separation.Hausdorff

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 171. k₂-Hausdorff -/
class K2T2Space (X : Type u) [TopologicalSpace X] : Prop where
  closed_continuous : ∀ ⦃K : Type u⦄ {_ : TopologicalSpace K} (f : K → X × X),
    T2Space K → CompactSpace K → Continuous f → IsClosed (f ⁻¹' (diagonal X))

end PiBase
