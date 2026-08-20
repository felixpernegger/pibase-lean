module

public import Mathlib.Topology.Metrizable.Basic

@[expose] public section

universe u v

open Topology Set Filter Function

namespace PiBase.AlphaTransport

section AIGenerated

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem mem_range_symm_comp (φ : X ≃ₜ Y) (f : ℕ → Y) (w : X) :
    w ∈ range (φ.symm ∘ f) ↔ φ w ∈ range f := by
  constructor
  · rintro ⟨m, hm⟩
    refine ⟨m, ?_⟩
    rw [← hm]
    exact (φ.apply_symm_apply (f m)).symm
  · rintro ⟨m, hm⟩
    refine ⟨m, ?_⟩
    change φ.symm (f m) = w
    rw [hm, φ.symm_apply_apply]

theorem mem_range_comp (φ : X ≃ₜ Y) (g : ℕ → X) (z : Y) :
    z ∈ range (φ ∘ g) ↔ φ.symm z ∈ range g := by
  constructor
  · rintro ⟨k, hk⟩
    refine ⟨k, ?_⟩
    rw [← hk]
    exact (φ.symm_apply_apply (g k)).symm
  · rintro ⟨k, hk⟩
    refine ⟨k, ?_⟩
    change φ (g k) = z
    rw [hk, φ.apply_symm_apply]

theorem tendsto_symm_comp (φ : X ≃ₜ Y) {f : ℕ → Y} {y : Y}
    (hf : Tendsto f atTop (𝓝 y)) : Tendsto (φ.symm ∘ f) atTop (𝓝 (φ.symm y)) :=
  (φ.symm.continuous.tendsto y).comp hf

theorem tendsto_comp_of_symm (φ : X ≃ₜ Y) {g : ℕ → X} {y : Y}
    (hg : Tendsto g atTop (𝓝 (φ.symm y))) : Tendsto (φ ∘ g) atTop (𝓝 y) := by
  have h := (φ.continuous.tendsto (φ.symm y)).comp hg
  rwa [φ.apply_symm_apply y] at h

theorem range_comp_subset (φ : X ≃ₜ Y) (f : ℕ → ℕ → Y) (g : ℕ → X)
    (h : range g ⊆ ⋃ n, range (φ.symm ∘ f n)) : range (φ ∘ g) ⊆ ⋃ n, range (f n) := by
  intro z hz
  rw [mem_range_comp φ g z] at hz
  obtain ⟨n, hn⟩ := mem_iUnion.1 (h hz)
  refine mem_iUnion.2 ⟨n, ?_⟩
  have hmem := (mem_range_symm_comp φ (f n) (φ.symm z)).1 hn
  rwa [φ.apply_symm_apply] at hmem

theorem symm_image_range_diff (φ : X ≃ₜ Y) (f : ℕ → Y) (g : ℕ → X) :
    range (φ.symm ∘ f) \ range g = φ.symm '' (range f \ range (φ ∘ g)) := by
  ext w
  constructor
  · rintro ⟨hw₁, hw₂⟩
    refine ⟨φ w, ⟨(mem_range_symm_comp φ f w).1 hw₁, ?_⟩, φ.symm_apply_apply w⟩
    rw [mem_range_comp φ g (φ w), φ.symm_apply_apply]
    exact hw₂
  · rintro ⟨z, ⟨hz₁, hz₂⟩, rfl⟩
    rw [mem_range_comp φ g z] at hz₂
    refine ⟨(mem_range_symm_comp φ f (φ.symm z)).2 ?_, hz₂⟩
    rwa [φ.apply_symm_apply]

theorem finite_diff_iff (φ : X ≃ₜ Y) (f : ℕ → Y) (g : ℕ → X) :
    (range f \ range (φ ∘ g)).Finite ↔ (range (φ.symm ∘ f) \ range g).Finite := by
  rw [symm_image_range_diff φ f g, Set.finite_image_iff φ.symm.injective.injOn]

theorem symm_range_inter_symm (φ : X ≃ₜ Y) (f₁ f₂ : ℕ → Y) :
    range (φ.symm ∘ f₁) ∩ range (φ.symm ∘ f₂) = φ.symm '' (range f₁ ∩ range f₂) := by
  ext w
  constructor
  · rintro ⟨hw₁, hw₂⟩
    exact ⟨φ w, ⟨(mem_range_symm_comp φ f₁ w).1 hw₁,
      (mem_range_symm_comp φ f₂ w).1 hw₂⟩, φ.symm_apply_apply w⟩
  · rintro ⟨z, ⟨hz₁, hz₂⟩, rfl⟩
    refine ⟨(mem_range_symm_comp φ f₁ (φ.symm z)).2 ?_,
      (mem_range_symm_comp φ f₂ (φ.symm z)).2 ?_⟩
    · rwa [φ.apply_symm_apply]
    · rwa [φ.apply_symm_apply]

theorem symm_pairwise_disjoint (φ : X ≃ₜ Y) (S : ℕ → ℕ → Y)
    (h : Pairwise fun n m ↦ range (S n) ∩ range (S m) = ∅) :
    Pairwise fun n m ↦ range (φ.symm ∘ S n) ∩ range (φ.symm ∘ S m) = ∅ := by
  intro n m hnm
  rw [symm_range_inter_symm φ (S n) (S m), h hnm, Set.image_empty]

theorem infinite_setOf_finite_diff (φ : X ≃ₜ Y) (S : ℕ → ℕ → Y) (T : ℕ → X)
    (h : {n | (range (φ.symm ∘ S n) \ range T).Finite}.Infinite) :
    {n | (range (S n) \ range (φ ∘ T)).Finite}.Infinite := by
  have hEq : {n | (range (φ.symm ∘ S n) \ range T).Finite}
      = {n | (range (S n) \ range (φ ∘ T)).Finite} := by
    ext n
    exact (finite_diff_iff φ (S n) T).symm
  rwa [hEq] at h

theorem symm_image_range_inter (φ : X ≃ₜ Y) (f : ℕ → Y) (g : ℕ → X) :
    range (φ.symm ∘ f) ∩ range g = φ.symm '' (range f ∩ range (φ ∘ g)) := by
  ext w
  constructor
  · rintro ⟨hw₁, hw₂⟩
    refine ⟨φ w, ⟨(mem_range_symm_comp φ f w).1 hw₁, ?_⟩, φ.symm_apply_apply w⟩
    rw [mem_range_comp φ g (φ w), φ.symm_apply_apply]
    exact hw₂
  · rintro ⟨z, ⟨hz₁, hz₂⟩, rfl⟩
    rw [mem_range_comp φ g z] at hz₂
    refine ⟨(mem_range_symm_comp φ f (φ.symm z)).2 ?_, hz₂⟩
    rwa [φ.apply_symm_apply]

theorem infinite_inter_iff (φ : X ≃ₜ Y) (f : ℕ → Y) (g : ℕ → X) :
    (range f ∩ range (φ ∘ g)).Infinite ↔ (range (φ.symm ∘ f) ∩ range g).Infinite := by
  rw [symm_image_range_inter φ f g, Set.infinite_image_iff φ.symm.injective.injOn]

theorem infinite_setOf_infinite_inter (φ : X ≃ₜ Y) (S : ℕ → ℕ → Y) (T : ℕ → X)
    (h : {n | (range (φ.symm ∘ S n) ∩ range T).Infinite}.Infinite) :
    {n | (range (S n) ∩ range (φ ∘ T)).Infinite}.Infinite := by
  have hEq : {n | (range (φ.symm ∘ S n) ∩ range T).Infinite}
      = {n | (range (S n) ∩ range (φ ∘ T)).Infinite} := by
    ext n
    exact (infinite_inter_iff φ (S n) T).symm
  rwa [hEq] at h

theorem nonempty_inter_iff (φ : X ≃ₜ Y) (f : ℕ → Y) (g : ℕ → X) :
    (range f ∩ range (φ ∘ g)).Nonempty ↔ (range (φ.symm ∘ f) ∩ range g).Nonempty := by
  rw [symm_image_range_inter φ f g, Set.image_nonempty]

theorem infinite_setOf_nonempty_inter (φ : X ≃ₜ Y) (S : ℕ → ℕ → Y) (T : ℕ → X)
    (h : {n | (range (φ.symm ∘ S n) ∩ range T).Nonempty}.Infinite) :
    {n | (range (S n) ∩ range (φ ∘ T)).Nonempty}.Infinite := by
  have hEq : {n | (range (φ.symm ∘ S n) ∩ range T).Nonempty}
      = {n | (range (S n) ∩ range (φ ∘ T)).Nonempty} := by
    ext n
    exact (nonempty_inter_iff φ (S n) T).symm
  rwa [hEq] at h

end AIGenerated

end PiBase.AlphaTransport
