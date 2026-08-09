module

public import Mathlib.Topology.Bases
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 10. Semiregular -/
class SemiregularSpace (X : Type*) [TopologicalSpace X] : Prop where
  semiregular : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsRegularOpen s

end PiBase

namespace PiBase.Formal

def P10 : Property where
  toPred := SemiregularSpace
  well_defined φ h := by
    rcases h.semiregular with ⟨B, Bβ, Br⟩
    refine ⟨Set.image φ '' B, Bβ.isQuotientMap φ.isQuotientMap φ.isOpenMap, ?_⟩
    rintro _ ⟨s, sB, rfl⟩
    unfold IsRegularOpen
    rw [← φ.image_closure, ← φ.image_interior, Br s sB]

end PiBase.Formal
