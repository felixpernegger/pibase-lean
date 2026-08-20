module

public import PiBaseLean.AdditionalDefs.Cardinal
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.DiscreteSubset

@[expose] public section

open Topology Set Filter TopologicalSpace Cardinal

universe u

namespace PiBase

/- 197. Has countable spread -/
class HasCountableSpread (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Spread X = ℵ₀

end PiBase

namespace PiBase.Formal

def P197 : Property where
  toPred := HasCountableSpread
  well_defined {X Y} _ _ φ h := by
    rcases h with ⟨h_eq_X⟩
    -- discrete preserved by homeomorphic image via φ.image : s ≃ₜ φ '' s
    have hDiscImage : ∀ {s : Set _} (_ : IsDiscrete s), IsDiscrete (φ '' s) := by
      intro s hs
      have hDT : DiscreteTopology s := isDiscrete_iff_discreteTopology.mp hs
      have hDT' : DiscreteTopology (φ '' s) := by
        have := hDT
        exact (φ.image s).discreteTopology
      exact isDiscrete_iff_discreteTopology.mpr hDT'
    have hDiscPre : ∀ {t : Set _} (_ : IsDiscrete t), IsDiscrete (φ ⁻¹' t) := by
      intro t ht
      have h_pre_eq : φ ⁻¹' t = φ.symm '' t := by
        ext x
        constructor
        · intro hx
          exact ⟨φ x, hx, by simp⟩
        · rintro ⟨y, hy, rfl⟩
          simp [hy]
      rw [h_pre_eq]
      have hDT : DiscreteTopology t := isDiscrete_iff_discreteTopology.mp ht
      have hDT' : DiscreteTopology (φ.symm '' t) := by
        have := hDT
        exact (φ.symm.image t).discreteTopology
      exact isDiscrete_iff_discreteTopology.mpr hDT'
    have hSpread_eq : Spread X = Spread Y := by
      unfold Spread
      congr 1
      apply congrArg sSup
      ext c
      constructor
      · rintro ⟨D, hDc, hDisc⟩
        exact ⟨φ '' D, by rw [mk_image_eq φ.injective, hDc], hDiscImage hDisc⟩
      · rintro ⟨D, hDc, hDisc⟩
        have hDisc' : IsDiscrete (φ ⁻¹' D) := hDiscPre hDisc
        have hCard : #(φ ⁻¹' D) = #D := by
          have h_eq : φ ⁻¹' D = φ.symm '' D := by
            ext x
            constructor
            · intro hx
              exact ⟨φ x, hx, by simp⟩
            · rintro ⟨y, hy, rfl⟩
              simp [hy]
          rw [h_eq, mk_image_eq φ.symm.injective]
        exact ⟨φ ⁻¹' D, by rw [hCard, hDc], hDisc'⟩
    -- hSpread_eq shows Spread X = Spread Y, so ℵ₀ is preserved
    constructor
    calc
      Spread Y = Spread X := hSpread_eq.symm
      _ = ℵ₀ := h_eq_X

end PiBase.Formal
