module

public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 86. Homogeneous -/
class HomogeneousSpace (X : Type*) [TopologicalSpace X] : Prop where
  homogeneous : ∀ (x y : X), ∃ f : X ≃ₜ X, f x = y

end PiBase

namespace PiBase.Formal

def P86 : Property where
  toPred := HomogeneousSpace
  well_defined φ h := by
    refine ⟨fun x y ↦ ?_⟩
    rcases h.homogeneous (φ.symm x) (φ.symm y) with ⟨e, ex⟩
    refine ⟨(φ.symm.trans e).trans φ, ?_⟩
    simp only [ex, Homeomorph.trans_apply, Homeomorph.apply_symm_apply]

end PiBase.Formal
