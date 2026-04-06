import Mathlib.Topology.Defs.Basic

universe u

namespace PiBase

/- 218. Ultranormal -/
class UltranormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  disjoint_clopen {s t : Set X} (st : s ∩ t = ∅) (hs : IsClosed s) (ht : IsClosed t) :
    ∃ r : Set X, IsClopen r ∧ s ⊆ r ∧ t ⊆ rᶜ

end PiBase
