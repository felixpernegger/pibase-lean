module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P135.Bundled
public import PiBaseLean.Properties.P139.Bundled
public import PiBaseLean.Properties.P36.Bundled
public import PiBaseLean.Theorems.T308.Lemmas

@[expose] public section

universe u

namespace PiBase

/-- Theorem T308:
R₀ (P135) + Has an isolated point (P139) + Nontivial (P125) => Not Connected (P26) -/
theorem instNotPreconnectedOfR0SpaceOfHasAnIsolatedPointOfNontrivial {X : Type u}
    [TopologicalSpace X] [R0Space X] [HasAnIsolatedPoint X] [h : Nontrivial X] :
    ¬ PreconnectedSpace X := by
  contrapose! h
  exact instSubsingletonOfPreconnectedSpaceOfR0SpaceOfHasAnIsolatedPoint X

end PiBase

namespace PiBase.Formal

theorem T308 : P135 ⊓ P139 ⊓ P125 ≤ P36ᶜ := fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
  @instNotPreconnectedOfR0SpaceOfHasAnIsolatedPointOfNontrivial X _ h1 h2 h3

end PiBase.Formal
