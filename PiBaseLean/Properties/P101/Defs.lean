module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 101. Has closed retracts -/
class HasClosedRetract (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_retract : ∀ A : Set X, IsRetract A → IsClosed A

end PiBase

namespace PiBase.Formal

def P101 : Property where
  toPred := HasClosedRetract
  well_defined {X Y} _ _ φ h := by
    refine ⟨fun s rs ↦ ?_⟩
    suffices r' : IsRetract (⇑φ ⁻¹' s) by simpa using h.has_closed_retract _ r'
    rcases rs with ⟨f, ff, rf⟩
    refine ⟨((φ.symm : C(Y, X)).comp f).comp (φ : C(X, Y)), ?_, ?_⟩
    · ext x
      simpa using DFunLike.congr_fun ff (φ x)
    · simp only [ContinuousMap.comp_assoc, ContinuousMap.coe_comp, ContinuousMap.coe_coe,
        range_comp, EquivLike.range_eq_univ, image_univ, ← rf]
      exact (φ.toEquiv.image_symm_eq_preimage s).symm

end PiBase.Formal
