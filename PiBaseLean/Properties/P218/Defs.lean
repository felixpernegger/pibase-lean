module

public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 218. Ultranormal -/
class UltranormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  disjoint_clopen {s t : Set X} (st : Disjoint s t) (hs : IsClosed s) (ht : IsClosed t) :
    ∃ r : Set X, IsClopen r ∧ s ⊆ r ∧ t ⊆ rᶜ

end PiBase

namespace PiBase.Formal

def P218 : Property where
  toPred := UltranormalSpace
  well_defined φ h := sorry

end PiBase.Formal
