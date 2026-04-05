import Mathlib.Order.ConditionallyCompleteLattice.Basic
import Mathlib.Topology.Defs.Basic

universe u

namespace PiBase

/- 231. Weakly first countable -/
class WeaklyFirstCountableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nhds_countable_weak_basis :
    ∃ V : X → ℕ → Set X, (∀ (x : X), Antitone (V x) ∧ ∀ (n : ℕ), x ∈ V x n)
      ∧ ∀ O : Set X, IsOpen O ↔ ∀ x ∈ O, ∃ k : ℕ, V x k ⊆ O

end PiBase
