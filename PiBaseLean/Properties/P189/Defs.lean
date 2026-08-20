module

public import Mathlib.Data.Setoid.Partition
public import Mathlib.Topology.Connected.Basic

@[expose] public section

open Topology Set Filter TopologicalSpace Function

universe u

namespace PiBase

/- 189. σ-connected -/
class SigmaConnectedSpace (X : Type u) [TopologicalSpace X] : Prop extends PreconnectedSpace X where
  no_partition :
    ∀ f : ℕ → Set X, Injective f ∧ Setoid.IsPartition (range f) → ∃ n : ℕ, ¬ IsClosed (f n)

end PiBase
