module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P232.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section FundGroupImage

variable {A B Z W : Type*} [TopologicalSpace A] [TopologicalSpace B] [TopologicalSpace Z]
  [TopologicalSpace W]

/-- `HasTrivialFundGroupImageAt` stated on elements of the fundamental group. -/
private theorem hasTrivialFundGroupImageAt_iff {f : C(A, B)} {a : A} :
    HasTrivialFundGroupImageAt f a ↔ ∀ p, FundamentalGroup.map f a p = 1 := by
  simp [HasTrivialFundGroupImageAt, MonoidHom.range_eq_bot_iff, DFunLike.ext_iff]

/-- Functoriality of `FundamentalGroup.map`, stated on elements. -/
private theorem fundGroup_map_comp (f : C(A, B)) (g : C(B, Z)) (a : A) (p : FundamentalGroup A a) :
    FundamentalGroup.map (g.comp f) a p =
      FundamentalGroup.map g (f a) (FundamentalGroup.map f a p) :=
  Path.Homotopic.Quotient.map_comp

/-- A map factoring through `f` has trivial fundamental group image whenever `f` does. -/
private theorem hasTrivialFundGroupImageAt_comp (e : C(A, B)) (f : C(B, Z)) (g : C(Z, W)) (a : A)
    (h : HasTrivialFundGroupImageAt f (e a)) :
    HasTrivialFundGroupImageAt (g.comp (f.comp e)) a := by
  rw [hasTrivialFundGroupImageAt_iff] at h ⊢
  intro p
  rw [fundGroup_map_comp (f.comp e) g a p, fundGroup_map_comp e f a p, h, map_one]

end FundGroupImage

/-- `LC¹` is transported along a homeomorphism.

Given `y : Y` and `M ∈ 𝓝 y`, pull `M` back to `N = e ⁻¹' M ∈ 𝓝 (e.symm y)` and let
`eN : ↥N ≃ₜ ↥M` be the induced homeomorphism. A witness `U ⊆ ↥N` for `X` transports to
`eN.symm ⁻¹' U = eN '' U`, whose inclusion into `↥M` factors as
`eN ∘ (U ↪ N) ∘ (eN.symm ⁻¹' U ≃ₜ U)`, so functoriality of `FundamentalGroup.map` kills it. -/
theorem lC1_of_homeomorph {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (e : X ≃ₜ Y) (h : LC1 X) : LC1 Y where
  contractible_nbhd {y} {M} hM := by
    have hN : e ⁻¹' M ∈ 𝓝 (e.symm y) :=
      e.continuous.continuousAt.preimage_mem_nhds (by rwa [e.apply_symm_apply])
    obtain ⟨U, hUpath, hU, hUtriv⟩ := h.contractible_nbhd hN
    let eN : ↥(e ⁻¹' M) ≃ₜ ↥M := e.sets (t := M) rfl
    have hV : eN.symm ⁻¹' U ∈ 𝓝 (⟨y, mem_of_mem_nhds hM⟩ : ↥M) :=
      eN.continuous_symm.continuousAt.preimage_mem_nhds hU
    refine ⟨eN.symm ⁻¹' U, ?_, hV, ?_⟩
    · rw [Homeomorph.preimage_symm]
      exact hUpath.image eN.continuous
    · let eV : ↥(eN.symm ⁻¹' U) ≃ₜ ↥U := eN.symm.sets (t := U) rfl
      let r : C(↥(eN.symm ⁻¹' U), ↥U) := ⟨eV, eV.continuous⟩
      let iU : C(↥U, ↥(e ⁻¹' M)) := ⟨Subtype.val, continuous_subtype_val⟩
      let eC : C(↥(e ⁻¹' M), ↥M) := ⟨eN, eN.continuous⟩
      have hcomp : eC.comp (iU.comp r) =
          (⟨Subtype.val, continuous_subtype_val⟩ : C(↥(eN.symm ⁻¹' U), ↥M)) :=
        ContinuousMap.ext fun v => eN.apply_symm_apply v.val
      rw [← hcomp]
      exact hasTrivialFundGroupImageAt_comp r iU eC _ hUtriv

open PiBase

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.lC1 (f : X ≃ₜ Y) [LC1 X] : LC1 Y :=
  lC1_of_homeomorph f inferInstance

theorem WellDefined.lC1 : WellDefined LC1 :=
  fun {_ _} _ _ h _ => Homeomorph.lC1 h.some

end Meta

end PiBase
