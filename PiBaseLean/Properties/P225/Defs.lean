module

public import Mathlib.Topology.UnitInterval

@[expose] public section

universe u

namespace PiBase

open Topology Set

/- 225. LC -/
class LCSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_contractible (x : X) (s : Set X) (h : s ∈ 𝓝 x) :
    ∃ t : Set X, t ∈ 𝓝 x ∧
      ∃ f : t × unitInterval → X, Continuous f ∧ range f ⊆ s ∧
        (∀ i, f (i, 0) = i.val) ∧  (∀ i, f (i, 1) = x)

end PiBase
