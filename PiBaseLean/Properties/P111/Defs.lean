import Mathlib.Data.Countable.Defs
import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Topology Set

universe u

namespace PiBase

/- 111. Hemicompact -/
class HemicompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  hemicompact : ∃ (ι : Type u) (K : ι → Set X), Countable ι ∧
    (∀ i, IsCompact (K i)) ∧ ⋃ i, K i = univ ∧ ∀ t : Set X, IsCompact t → ∃ i : ι, t ⊆ K i

end PiBase

namespace PiBase.Formal

def P111 : Property where
  toPred := HemicompactSpace
  well_defined' φ h := sorry

end PiBase.Formal
