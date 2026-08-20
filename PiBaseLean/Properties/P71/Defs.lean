module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 71. σ-relatively compact -/
class SigmaRelativelyCompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  sigma_relatively_compact : ∃ R : ℕ → Set X, (⋃ n : ℕ, R n = univ) ∧
    ∀ n : ℕ, IsRelativelyCompact (R n)

end PiBase
