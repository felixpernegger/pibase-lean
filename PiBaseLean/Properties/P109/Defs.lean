module

public import Mathlib.Topology.Sets.Opens

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 109. Monotonically normal -/
class MonotonicallyNormalSpace (X : Type*) [TopologicalSpace X] : Prop extends T1Space X where
  monotonically_normal : ∃ μ : (x : X) → (s : Opens X) → (hs : x ∈ s) → Opens X,
    ∀ (x : X) (s : Opens X) (hs : x ∈ s), x ∈ μ x s hs ∧
      ∀ (x y : X) (u v : Opens X) (hu : x ∈ u) (hv : y ∈ v),
        (↑(μ x u hu) : Set X) ∩ ↑(μ y v hv) ≠ ∅ → x ∈ v ∨ y ∈ u

end PiBase
