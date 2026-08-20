module

public import Mathlib.Order.ConditionallyCompleteLattice.Basic
public import Mathlib.Topology.Defs.Basic

@[expose] public section

namespace PiBase

/- 228. Weakly first countable -/
class WeaklyFirstCountableSpace (X : Type*) [TopologicalSpace X] : Prop where
  nhds_countable_weak_basis :
    ∃ V : X → ℕ → Set X, (∀ (x : X), Antitone (V x) ∧ ∀ (n : ℕ), x ∈ V x n)
      ∧ ∀ O : Set X, IsOpen O ↔ ∀ x ∈ O, ∃ k : ℕ, V x k ⊆ O

end PiBase
