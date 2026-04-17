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
    X → SeparationQuotient (OnePoint X) := fun x ↦ SeparationQuotient.mk x

lemma OnePoint.toSeparationQuotient_wellDefined {X : Type u} [TopologicalSpace X] :
    ∀ x y : X, Inseparable x y →
      toSeparationQuotient x = toSeparationQuotient y := fun _ _ _ ↦ by
  simpa [toSeparationQuotient]

def OnePoint.ofSeparationQuotient {X : Type u} [TopologicalSpace X] :
    OnePoint X → OnePoint (SeparationQuotient X)
  | ∞ => ∞
  | some x => SeparationQuotient.mk x

lemma OnePoint.continuous_ofSeparationQuotient (X : Type u) [TopologicalSpace X] :
    Continuous (ofSeparationQuotient (X := X)) := by
  refine (OnePoint.continuous_iff ofSeparationQuotient).mpr ⟨?_, ?_⟩
  · apply tendsto_nhds.mpr (fun s so is ↦ ?_)
    simp only [ofSeparationQuotient]
    apply mem_coclosedCompact_iff.mpr
    have : (fun x : X ↦ ↑(SeparationQuotient.mk x)) ⁻¹' s =
      SeparationQuotient.mk ⁻¹' (OnePoint.some ⁻¹' s) := by
      ext
      simp
    rw [this, ← preimage_compl]
    have : closure (SeparationQuotient.mk ⁻¹' (OnePoint.some ⁻¹' s)ᶜ) =
        SeparationQuotient.mk ⁻¹' (OnePoint.some ⁻¹' s)ᶜ := by
      apply closure_eq_iff_isClosed.mpr <| IsClosed.preimage SeparationQuotient.continuous_mk ?_
      rw [isClosed_compl_iff]
      exact Continuous.isOpen_preimage OnePoint.continuous_coe s so
    rw [this]
    refine IsInducing.isCompact_preimage SeparationQuotient.isInducing_mk ?_ ?_
    · simp
    · exact (OnePoint.isOpen_def.mp so).1 is
  · simp_rw [ofSeparationQuotient]
    exact Continuous.comp OnePoint.continuous_coe SeparationQuotient.continuous_mk

lemma OnePoint.ofSeparationQuotient_wellDefined {X : Type u} [TopologicalSpace X] :
    ∀ x y : OnePoint X, Inseparable x y →
      ofSeparationQuotient x = ofSeparationQuotient y := by
  intro _ _ h
  rw [OnePoint.inseparable_iff] at h
  rcases h with ⟨rfl, rfl⟩ | ⟨_, rfl, _, rfl, _⟩
  · rfl
  · simpa [ofSeparationQuotient]

theorem OnePoint.isCompact_preimage {X : Type u} [TopologicalSpace X] {s : Set (OnePoint X)}
    (hs : IsCompact s) (si : ∞ ∉ s) : IsCompact (OnePoint.some ⁻¹' s) := by
  apply OnePoint.isOpenEmbedding_coe.isInducing.isCompact_preimage' hs
  rintro (_ | _) h
  · exact absurd h si
  · exact mem_range_self _

lemma OnePoint.subset_range_some {X : Type u} [TopologicalSpace X]
    {s : Set (OnePoint X)} (hs : ∞ ∉ s) : s ⊆ range OnePoint.some := by
  rw [← OnePoint.compl_infty]
  simpa

theorem OnePoint.isCompact_of_closed {X : Type u} [TopologicalSpace X] {s : Set (OnePoint X)}
    (hs : IsClosed s) (hi : ∞ ∉ s) : IsCompact s := by
  rw [OnePoint.isClosed_iff_of_notMem hi] at hs
  rw [← image_preimage_eq_of_subset <| subset_range_some hi]
  exact IsCompact.image hs.2 OnePoint.continuous_coe

def OnePoint.SeparationQuotient (X : Type u) [TopologicalSpace X] :
    SeparationQuotient (OnePoint X) ≃ₜ OnePoint (SeparationQuotient X) where
  toFun := SeparationQuotient.lift ofSeparationQuotient ofSeparationQuotient_wellDefined
  invFun x := match x with
    | ∞ => SeparationQuotient.mk ∞
    | some x => SeparationQuotient.lift toSeparationQuotient toSeparationQuotient_wellDefined x
  left_inv x := by
    obtain ⟨y, rfl⟩ := SeparationQuotient.surjective_mk x
    match y with
    | ∞ => simp [ofSeparationQuotient]
    | some x => simp [ofSeparationQuotient, toSeparationQuotient]; rfl
  right_inv x := by
    match x with
    | ∞ => simp [ofSeparationQuotient]
    | some x =>
      obtain ⟨y, rfl⟩ := SeparationQuotient.surjective_mk x
      simp [toSeparationQuotient, ofSeparationQuotient]; rfl
  continuous_toFun := SeparationQuotient.continuous_lift.mpr <| continuous_ofSeparationQuotient X
  continuous_invFun := by
    apply continuous_iff_continuousAt.mpr
    intro x
    match x with
    | ∞ =>
      apply OnePoint.continuousAt_infty.mpr (fun s hs ↦ ?_)
      obtain ⟨l, ls, o, hl⟩ := mem_nhds_iff.mp hs
      refine ⟨SeparationQuotient.mk '' (OnePoint.some ⁻¹' (SeparationQuotient.mk ⁻¹' l))ᶜ,
        ?_, ?_, ?_⟩
      · apply SeparationQuotient.isClosedMap_mk <| OnePoint.some ⁻¹' (SeparationQuotient.mk ⁻¹' l)ᶜ
        exact (isClosed_compl_iff.mpr <| OnePoint.isOpen_def.mpr o).preimage OnePoint.continuous_coe
      · apply (IsInducing.isCompact_iff SeparationQuotient.isInducing_mk).mp
        rw [← preimage_compl, ← preimage_compl]
        rw [← notMem_compl_iff] at hl
        refine OnePoint.isCompact_preimage (OnePoint.isCompact_of_closed ?_ ?_) hl
        · apply IsClosed.preimage SeparationQuotient.continuous_mk o.isClosed_compl
        · simp_all
      · intro x hx
        obtain ⟨y, hy⟩ := SeparationQuotient.surjective_mk x
        rw [← hy] at hx ⊢
        simp only [mem_compl_iff, mem_image, mem_preimage, SeparationQuotient.mk_eq_mk, not_exists,
          not_and, comp_apply, SeparationQuotient.lift_mk, toSeparationQuotient] at hx ⊢
        exact ls <| not_notMem.mp <| .intro fun a ↦ hx y a rfl
    | some x =>
      apply OnePoint.continuousAt_coe.mpr <| Continuous.continuousAt ?_
      apply (IsQuotientMap.continuous_iff SeparationQuotient.isQuotientMap_mk).mpr
      refine (continuous_congr (f := SeparationQuotient.mk ∘ OnePoint.some) ?_).mp ?_
      · simp [toSeparationQuotient]
      · exact SeparationQuotient.continuous_mk.comp OnePoint.continuous_coe

instance OnePoint.instR0Space {X : Type u}
    [TopologicalSpace X] [t : R0Space X] : R0Space (OnePoint X) :=
  have : T1Space (OnePoint (_root_.SeparationQuotient X)) :=
    @OnePoint.instT1Space (_root_.SeparationQuotient X) _ <| SeparationQuotient.t1Space_iff.mpr t
  SeparationQuotient.t1Space_iff.mp <| Homeomorph.t1Space (OnePoint.SeparationQuotient X).symm

end PiBase
