import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Filter Function PiBase.AdditionalDefs

namespace PiBase

/- 217. Strongly zero dimensional space -/
class StronglyZeroDimensionalSpace (X : Type*) [TopologicalSpace X] : Prop where
  disjoint_clopen {s t : Set X} (hs : IsZero s) (ht : IsZero t) (st : s ∩ t = ∅) :
    ∃ s' t' : Set X, IsClopen s' ∧ IsClopen t' ∧ s ⊆ s' ∧ t ⊆ t' ∧ s' ∩ t' = ∅

end PiBase

namespace PiBase.Formal

def P217 : Property where
  toPred := StronglyZeroDimensionalSpace
  well_defined' φ h := sorry

end PiBase.Formal
