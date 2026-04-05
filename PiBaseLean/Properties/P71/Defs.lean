import PiBaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 71. σ-relatively compact -/
class SigmaRelativelyCompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  sigma_relatively_compact : ∃ R : ℕ → Set X, X = ⋃ n : ℕ, R n ∧ ∀ n : ℕ, IsRelativelyCompact (R n)

end PiBase
