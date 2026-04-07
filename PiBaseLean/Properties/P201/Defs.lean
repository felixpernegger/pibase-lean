import Mathlib.Topology.Sober
import PiBaseLean.Properties.Bundled.Defs

open Set Topology Filter

namespace PiBase

/-- 201. Has a generic point -/
class HasGenericPoint (X : Type*) [TopologicalSpace X] : Prop where
  ex_generic_point : ∃ p : X, IsGenericPoint p Set.univ

end PiBase

namespace PiBase.Formal

def P201 : Property where
  toPred := HasGenericPoint
  well_defined φ h := by
    rcases h.ex_generic_point with ⟨x, xg⟩
    refine ⟨φ x, ?_⟩
    simp only [IsGenericPoint] at xg ⊢
    simpa [φ.image_closure] using congrArg (Set.image φ) xg

end PiBase.Formal
