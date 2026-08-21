module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P183.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.hasCountableKNetwork [HasCountableKNetwork X] (f : X ≃ₜ Y) :
    HasCountableKNetwork Y := by
  rcases ‹HasCountableKNetwork X› with ⟨ι, g, hι_cnt, hg⟩
  refine ⟨ι, fun i => f '' g i, hι_cnt, ?_⟩
  intro U K hUo hKc hKU
  have hU' : IsOpen (f ⁻¹' U) := f.isOpen_preimage.mpr hUo
  have hK'_eq : f ⁻¹' K = f.symm '' K := by
    ext x
    constructor
    · intro hx
      exact ⟨f x, hx, by simp⟩
    · rintro ⟨y, hy, rfl⟩
      simp [hy]
  have hK' : IsCompact (f ⁻¹' K) := by
    rw [hK'_eq]
    exact hKc.image f.symm.continuous
  have hKU' : f ⁻¹' K ⊆ f ⁻¹' U := preimage_mono hKU
  obtain ⟨s, hK's, hUs⟩ := hg (f ⁻¹' U) (f ⁻¹' K) hU' hK' hKU'
  refine ⟨s, ?_, ?_⟩
  · intro y hyK
    have hy' : y ∈ f '' (f ⁻¹' K) := by
      rw [f.image_preimage]
      exact hyK
    rcases hy' with ⟨x, hxK, rfl⟩
    have hxU : x ∈ ⋃ i ∈ s, g i := hK's hxK
    rcases Set.mem_iUnion₂.mp hxU with ⟨i, hi, hxi⟩
    exact Set.mem_iUnion₂.mpr ⟨i, hi, ⟨x, hxi, rfl⟩⟩
  · intro y hy
    rcases Set.mem_iUnion₂.mp hy with ⟨i, hi, hx⟩
    rcases hx with ⟨x, hxf, rfl⟩
    have : x ∈ ⋃ i ∈ s, g i := Set.mem_iUnion₂.mpr ⟨i, hi, hxf⟩
    have : x ∈ f ⁻¹' U := hUs this
    exact this

theorem WellDefined.hasCountableKNetwork : WellDefined HasCountableKNetwork :=
  fun {_ _} _ _ h _ ↦ Homeomorph.hasCountableKNetwork h.some

end PiBase
