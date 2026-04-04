import Mathlib.Data.Countable.Defs
import Mathlib.Topology.Defs.Filter

open Topology Set

universe u

namespace PiBase

/- 111. Hemicompact -/
class HemicompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  hemicompact : ∃ (ι : Type u) (K : ι → Set X), Countable ι ∧
    (∀ i, IsCompact (K i)) ∧ ⋃ i, K i = univ ∧ ∀ t : Set X, IsCompact t → ∃ i : ι, t ⊆ K i

end PiBase
