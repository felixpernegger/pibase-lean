module

public import PiBaseLean.AdditionalDefs.Meta
public import Mathlib.Topology.Defs.Basic

@[expose] public section

universe u

namespace PiBase

/- 218. Ultranormal -/
class UltranormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  disjoint_clopen {s t : Set X} (st : Disjoint s t) (hs : IsClosed s) (ht : IsClosed t) :
    ∃ r : Set X, IsClopen r ∧ s ⊆ r ∧ t ⊆ rᶜ

end PiBase
