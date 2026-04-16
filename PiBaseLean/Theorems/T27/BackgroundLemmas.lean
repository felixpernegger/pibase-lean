module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P134.Defs
public import PiBaseLean.Properties.P12.Lemmas
public import Mathlib

@[expose] public section

universe u

open Set Function Topology Filter

open scoped OnePoint

namespace PiBase

def OnePoint.toSeparationQuotient {X : Type u} [TopologicalSpace X] :
    X → SeparationQuotient (OnePoint X) :=
  fun x ↦ SeparationQuotient.mk x

lemma OnePoint.toSeparationQuotient_wellDefined {X : Type u} [TopologicalSpace X] :
    ∀ x y : X, Inseparable x y →
      toSeparationQuotient x = toSeparationQuotient y := by
  intro x y xy
  simpa [toSeparationQuotient]

def OnePoint.ofSeparationQuotient {X : Type u} [TopologicalSpace X] :
    OnePoint X → OnePoint (SeparationQuotient X)
  | ∞ => ∞
  | some x => SeparationQuotient.mk x

lemma OnePoint.continuous_ofSeparationQuotient (X : Type u) [TopologicalSpace X] :
    Continuous (ofSeparationQuotient (X := X)) := by
  apply (OnePoint.continuous_iff ofSeparationQuotient).mpr ⟨?_, ?_⟩
  · refine tendsto_nhds.mpr (fun s so is ↦ ?_)
    simp only [ofSeparationQuotient]
    apply mem_coclosedCompact_iff.mpr
    have he := (OnePoint.isOpen_def.mp so).1 is
    set e := OnePoint.some ⁻¹' s
    have : (fun x : X ↦ ↑(SeparationQuotient.mk x)) ⁻¹' s = SeparationQuotient.mk ⁻¹' e := by
      ext x
      simp [e]
    rw [this, ← preimage_compl]
    have : closure (SeparationQuotient.mk ⁻¹' eᶜ) = SeparationQuotient.mk ⁻¹' eᶜ := by
      refine closure_eq_iff_isClosed.mpr ?_
      refine IsClosed.preimage SeparationQuotient.continuous_mk ?_
      simp only [isClosed_compl_iff, e]
      exact Continuous.isOpen_preimage OnePoint.continuous_coe s so
    rw [this]
    refine IsInducing.isCompact_preimage SeparationQuotient.isInducing_mk ?_ he
    simp
  · simp_rw [ofSeparationQuotient]
    exact Continuous.comp OnePoint.continuous_coe SeparationQuotient.continuous_mk

lemma OnePoint.ofSeparationQuotient_wellDefined {X : Type u} [TopologicalSpace X] :
    ∀ x y : OnePoint X, Inseparable x y →
      ofSeparationQuotient x = ofSeparationQuotient y := by
  intro x y xy
  rw [OnePoint.inseparable_iff] at xy
  rcases xy with h|h
  · rw [h.1, h.2]
  obtain ⟨x', hx', h⟩ := h
  obtain ⟨y', hy', xy⟩ := h
  rw [hx', hy']
  simpa [ofSeparationQuotient]

theorem OnePoint.isCompact_preimage {X : Type u} [TopologicalSpace X] {s : Set (OnePoint X)}
    (hs : IsCompact s) (si : ∞ ∉ s) : IsCompact (OnePoint.some ⁻¹' s) := by
  apply Topology.IsInducing.isCompact_preimage'
  · exact OnePoint.isOpenEmbedding_coe.isInducing
  · exact hs
  intro i _
  cases i
  · contradiction
  · exact mem_range_self _

def OnePoint.SeparationQuotient (X : Type u) [TopologicalSpace X] :
    SeparationQuotient (OnePoint X) ≃ₜ OnePoint (SeparationQuotient X) where
      toFun := SeparationQuotient.lift ofSeparationQuotient ofSeparationQuotient_wellDefined
      invFun x := match x with
        | ∞ => SeparationQuotient.mk (∞ : OnePoint X)
        | some x =>
          SeparationQuotient.lift toSeparationQuotient toSeparationQuotient_wellDefined x
      left_inv x := by
        obtain ⟨y, hy⟩ := SeparationQuotient.surjective_mk x
        rw [← hy]
        match y with
        | ∞ => simp [ofSeparationQuotient]
        | some x =>
          simp [ofSeparationQuotient, toSeparationQuotient]
          rfl
      right_inv x := by match x with
      | ∞ => simp [ofSeparationQuotient]
      | some x =>
          obtain ⟨y, hy⟩ := SeparationQuotient.surjective_mk x
          rw [← hy]
          simp [toSeparationQuotient, ofSeparationQuotient]
          rfl
      continuous_toFun :=
        SeparationQuotient.continuous_lift.mpr <| continuous_ofSeparationQuotient X
      continuous_invFun := by
        apply continuous_iff_continuousAt.mpr
        intro x; match x with
        | ∞ =>
          refine OnePoint.continuousAt_infty.mpr (fun s hs ↦ ?_)
          simp only at hs
          obtain ⟨l, ls, lo, hl⟩ := mem_nhds_iff.mp hs
          refine ⟨SeparationQuotient.mk '' (OnePoint.some ⁻¹' (SeparationQuotient.mk ⁻¹' l))ᶜ,
            ?_, ?_, ?_⟩
          · rw [← preimage_compl]
            suffices IsClosed (OnePoint.some ⁻¹' (SeparationQuotient.mk ⁻¹' l)ᶜ) from
              (SeparationQuotient.isClosedMap_mk (X := X))
                (OnePoint.some ⁻¹' (SeparationQuotient.mk ⁻¹' l)ᶜ) this
            refine IsClosed.preimage OnePoint.continuous_coe ?_
            simp only [isClosed_compl_iff]
            exact OnePoint.isOpen_def.mpr lo
          · apply (IsInducing.isCompact_iff SeparationQuotient.isInducing_mk).mp
            rw [← preimage_compl, ← preimage_compl]
            replace lo : IsClosed lᶜ := by exact IsOpen.isClosed_compl lo
            rw [← mem_preimage, ← notMem_compl_iff, ← preimage_compl] at hl
            apply OnePoint.isCompact_preimage _ hl
            refine IsInducing.isCompact_preimage SeparationQuotient.isInducing_mk ?_ ?_
            · exact SeparationQuotient.isClosedMap_mk.isClosed_range
            rw [← image_preimage_eq lᶜ SeparationQuotient.surjective_mk]
            refine IsCompact.image ?_ SeparationQuotient.continuous_mk
            rw [preimage_compl]
            simp only [isClosed_compl_iff] at lo
            simp only [preimage_compl, mem_compl_iff, mem_preimage, not_not] at hl
            have : OnePoint.some '' (OnePoint.some ⁻¹' ((@Quotient.mk' (OnePoint X)
                (inseparableSetoid (OnePoint X))) ⁻¹' l))ᶜ = (SeparationQuotient.mk ⁻¹' l)ᶜ := by
              ext s
              cases s
              · simpa
              simp only [mem_image, mem_compl_iff, mem_preimage, OnePoint.some_eq_iff,
                exists_eq_right]
              rfl
            rw [← this]
            exact ((OnePoint.isOpen_def.mp lo).1 <| mem_preimage.mpr hl).image
              OnePoint.continuous_coe
          · intro x hx
            obtain ⟨y, hy⟩ := SeparationQuotient.surjective_mk x
            rw [← hy] at hx ⊢
            simp only [mem_compl_iff, mem_image, mem_preimage, SeparationQuotient.mk_eq_mk,
              not_exists, not_and, comp_apply, SeparationQuotient.lift_mk,
              toSeparationQuotient] at hx ⊢
            apply ls
            contrapose! hx
            refine ⟨y, hx, SeparationQuotient.mk_eq_mk.mp rfl⟩
        | some x =>
          apply OnePoint.continuousAt_coe.mpr
          apply Continuous.continuousAt
          set r := fun (x : OnePoint (_root_.SeparationQuotient X)) ↦ match x with
            | ∞ => SeparationQuotient.mk (∞ : OnePoint X)
            | some x => SeparationQuotient.lift
              toSeparationQuotient toSeparationQuotient_wellDefined x
          apply (IsQuotientMap.continuous_iff SeparationQuotient.isQuotientMap_mk).mpr
          have : (r ∘ OnePoint.some) ∘ SeparationQuotient.mk
              = SeparationQuotient.mk ∘ OnePoint.some := by
            ext
            simp [r, toSeparationQuotient]
          rw [this]
          exact Continuous.comp SeparationQuotient.continuous_mk OnePoint.continuous_coe

instance OnePoint.instR0Space (X : Type u)
    [TopologicalSpace X] [t : R0Space X] : R0Space (OnePoint X) := by
  apply SeparationQuotient.t1Space_iff.mp
  have : T1Space (OnePoint (_root_.SeparationQuotient X)) :=
    @OnePoint.instT1Space (_root_.SeparationQuotient X) _ <| SeparationQuotient.t1Space_iff.mpr t
  exact Homeomorph.t1Space (OnePoint.SeparationQuotient X).symm

--todo: WLC + R1 => OnePoint R1

end PiBase
