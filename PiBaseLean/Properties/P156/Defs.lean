module

public import PiBaseLean.AdditionalDefs.Games

@[expose] public section

universe u

namespace PiBase

/- 156. k-Rothberger -/
class KRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  k_rothberger : ∀ {ι : Type u} (U : ℕ → ι → Set X), (∀ n, IsKCover'' (U n)) →
    ∃ j : ℕ → ι, IsKCover'' (fun n ↦ (U n) (j n))

end PiBase
