import Mathlib.Topology.Bases
import PiBaseLean.Properties.Bundled.Defs

open TopologicalSpace

namespace PiBase

/- 10. Semiregular -/
class SemiregularSpace (X : Type*) [TopologicalSpace X] : Prop where
  semiregular : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

end PiBase

namespace PiBase.Formal

def P10 : Property where
  toPred := SemiregularSpace
  well_defined φ h := by
    rcases h.semiregular with ⟨B, Bβ, Br⟩
    refine ⟨Set.image φ '' B, Bβ.isQuotientMap φ.isQuotientMap φ.isOpenMap, ?_⟩
    rintro _ ⟨s, sB, rfl⟩
    rw [← φ.image_closure, ← φ.image_interior, Br s sB]

end PiBase.Formal
