module

public import Mathlib.Topology.Separation.Hausdorff

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 143. Weak Hausdorff -/
class WeakT2Space (X : Type u) [TopologicalSpace X] : Prop where
  compact_closed : ∀ {K : Type u} (_ : TopologicalSpace K) ⦃f : K → X⦄,
    Continuous f → CompactSpace K → T2Space K → IsClosed (range f)

end PiBase
