module

public import Mathlib.Data.Countable.Defs
public import Mathlib.Topology.Compactness.Compact
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Topology Set

universe u

namespace PiBase

/- 111. Hemicompact -/
class HemicompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  hemicompact : ∃ (ι : Type u) (K : ι → Set X), Countable ι ∧
    (∀ i, IsCompact (K i)) ∧ ⋃ i, K i = univ ∧ ∀ t : Set X, IsCompact t → ∃ i : ι, t ⊆ K i

end PiBase
