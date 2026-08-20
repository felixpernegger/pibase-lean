module

public import PiBaseLean.AdditionalDefs.Cardinal
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.DiscreteSubset

@[expose] public section

open Topology Set Filter TopologicalSpace Cardinal

universe u

namespace PiBase

/- 198. Has countable extent -/
class HasCountableExtent (X : Type u) [TopologicalSpace X] : Prop where
  extent_eq : Extent X = ℵ₀

end PiBase

namespace PiBase.Formal

def P198 : Property where
  toPred := HasCountableExtent
  well_defined {X Y} _ _ φ h := by
    rcases h with ⟨h_eq_X⟩
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
    have hExtent_eq : Extent X = Extent Y := by
      unfold Extent
      congr 1
      apply congrArg sSup
      ext c
      constructor
      · rintro ⟨D, hDc, hCl, hDisc⟩
        exact ⟨φ '' D, by rw [mk_image_eq φ.injective, hDc], φ.isClosed_image.mpr hCl,
          hDiscImage hDisc⟩
      · rintro ⟨D, hDc, hCl, hDisc⟩
        have hDisc' : IsDiscrete (φ ⁻¹' D) := hDiscPre hDisc
        have hCl' : IsClosed (φ ⁻¹' D) := φ.isClosed_preimage.mpr hCl
        have hCard : #(φ ⁻¹' D) = #D := by
          have h_eq : φ ⁻¹' D = φ.symm '' D := by
            ext x
            constructor
            · intro hx
              exact ⟨φ x, hx, by simp⟩
            · rintro ⟨y, hy, rfl⟩
              simp [hy]
          rw [h_eq, mk_image_eq φ.symm.injective]
        exact ⟨φ ⁻¹' D, by rw [hCard, hDc], hCl', hDisc'⟩
    constructor
    calc
      Extent Y = Extent X := hExtent_eq.symm
      _ = ℵ₀ := h_eq_X

end PiBase.Formal
