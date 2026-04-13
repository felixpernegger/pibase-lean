module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P51.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

section Meta

theorem Homeomorph.scatteredSpace [h : ScatteredSpace X] (f : X ≃ₜ Y) : ScatteredSpace Y where
  scattered s hs := by
    obtain ⟨⟨p, hp⟩, hp'⟩ := h.scattered (f.toFun ⁻¹' s) <| Nonempty.preimage hs f.surjective
    refine ⟨⟨f p, hp⟩, ?_⟩
    rw [isOpen_mk] at hp' ⊢
    obtain ⟨t, ht, tp⟩ := hp'
    rw [Set.ext_iff] at tp
    refine ⟨f '' t, (Homeomorph.isOpen_image f).mpr ht, ?_⟩
    ext ⟨z, zs⟩
    simp_all only [Equiv.toFun_as_coe, Homeomorph.coe_toEquiv, mem_preimage, mem_singleton_iff,
      Subtype.forall, Subtype.mk.injEq, mem_image]
    refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
    · obtain ⟨r, rt, rz⟩ := h
      rw [← rz, ((tp r) (rz.symm ▸ zs)).mp rt]
    exact ⟨p, (tp p <| h.symm ▸ zs).mpr <| .refl p, h.symm⟩

theorem scatteredSpace : WellDefined ScatteredSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.scatteredSpace h.some

end Meta

end PiBase
