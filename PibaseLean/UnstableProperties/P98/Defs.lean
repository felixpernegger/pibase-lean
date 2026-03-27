import Mathlib

open Topology Set Function Filter TopologicalSpace Set.Notation

namespace UnstablePiBase

/- 98. k ω 1 space -/
class kωSpace' (X : Type*) [TopologicalSpace X] : Prop where
  k_omega : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

end UnstablePiBase
