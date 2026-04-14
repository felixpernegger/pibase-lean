module

public import PiBaseLean.Properties.P133.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 154. GO-space -/
class GoSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_lots : ∃ (Z : Type u) (s : Set Z) (_ : TopologicalSpace Z),
    Lots Z ∧ Nonempty (X ≃ₜ (↑s : Type u))

end PiBase

namespace PiBase.Formal

def P154 : Property where
  toPred := GoSpace
  well_defined φ h := sorry

end PiBase.Formal
