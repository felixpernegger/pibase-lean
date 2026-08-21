module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Set Set.Notation

namespace PiBase

/- 98. k ω 1 space -/
class kω1Space (X : Type*) [TopologicalSpace X] : Prop where
  k_omega : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

end PiBase
