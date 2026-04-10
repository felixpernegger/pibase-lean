module

public import Mathlib.Data.Setoid.Partition
public import Mathlib.Topology.Connected.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 189. σ-connected -/
class SigmaConnectedSpace (X : Type u) [TopologicalSpace X] : Prop extends ConnectedSpace X where
  no_partition : ∀ f : ℕ → Set X, Setoid.IsPartition (range f) → ∃ n : ℕ, ¬ IsClosed (f n)

end PiBase

namespace PiBase.Formal

def P189 : Property where
  toPred := SigmaConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
