import Mathlib

open Topology Set Function Filter TopologicalSpace

universe u

namespace UnstablePiBase

/- 111. Hemicompact -/
class HemicompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  hemicompact : ∃ (ι : Type u) (K : ι → Set X), Countable ι ∧
    (∀ i, IsCompact (K i)) ∧ ⋃ i, K i = Set.univ ∧ ∀ t : Set X, IsCompact t → ∃ i : ι, t ⊆ K i

end UnstablePiBase
