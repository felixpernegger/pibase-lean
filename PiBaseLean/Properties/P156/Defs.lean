module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

open Set

/- 156. k-Rothberger -/
class KRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  k_rothberger : ∀ {ι : Type u} (U : ℕ → ι → Set X), (∀ n, IsKCover'' (U n)) →
    ∃ j : ℕ → ι, IsKCover'' (fun n ↦ (U n) (j n))

end PiBase

namespace PiBase.Formal

def P156 : Property where
  toPred := KRothbergerSpace
  well_defined φ h := sorry

end PiBase.Formal
