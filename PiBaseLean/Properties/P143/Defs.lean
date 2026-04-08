module

public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 143. Weak Hausdorff -/
class WeakT2Space (X : Type u) [TopologicalSpace X] : Prop where
  compact_closed : ∀ {K : Type u} (_ : TopologicalSpace K) ⦃f : K → X⦄,
    Continuous f → CompactSpace K → T2Space K → IsClosed (range f)

end PiBase

namespace PiBase.Formal

def P143 : Property where
  toPred := WeakT2Space
  well_defined φ h := sorry

end PiBase.Formal
