module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

open Set

/- 159. k-Menger -/
class KMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  k_menger : ∀ {ι : Type u} (U : ℕ → ι → Set X), (∀ (n : ℕ), IsKCover'' (U n)) →
    ∃ s : ℕ → Finset ι, IsKCover' {U n i | (n : ℕ) (i : ι) (_ : i ∈ s n)}

end PiBase

namespace PiBase.Formal

def P159 : Property where
  toPred := KMengerSpace
  well_defined φ h := sorry

end PiBase.Formal
