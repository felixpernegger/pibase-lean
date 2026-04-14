module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P38.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

section Meta

theorem isInjPathConnectedSpace_of_injective_image {f : X → Y} (fc : Continuous f)
    {s : Set X} (fs : InjOn f s) (hs : IsInjPathConnected s) : IsInjPathConnected (f '' s) := by
  intro x y xy ⟨a, as, ax⟩ ⟨c, cs, cy⟩
  obtain ⟨p, pi, ps⟩ := hs (by contrapose! xy; rw [← ax, ← cy, xy]) as cs
  refine ⟨⟨⟨f ∘ p.toFun, fc.comp p.continuous⟩,
    by simp [p.source, ax], by simp [p.target, cy]⟩, ?_, ?_⟩
  · exact fun x y xy ↦ pi <| fs (ps ⟨x, Eq.refl (p x)⟩) (ps ⟨y, Eq.refl (p y)⟩) xy
  · exact fun a ⟨b, hb⟩ ↦ ⟨p b, ps ⟨b, .refl (p b)⟩, hb⟩

theorem injPathConnectedSpace_of_bijective_continuous [h : InjPathConnectedSpace X] {f : X → Y}
    (fc : Continuous f) (fb : Bijective f) :
    InjPathConnectedSpace Y where
  joined := by
    rw [← range_eq_univ.mpr fb.surjective, ← image_univ]
    exact isInjPathConnectedSpace_of_injective_image fc (injOn_univ.mpr fb.injective) h.joined

theorem Homeomorph.injPathConnectedSpace [InjPathConnectedSpace X] (f : X ≃ₜ Y) :
    InjPathConnectedSpace Y :=
  injPathConnectedSpace_of_bijective_continuous f.continuous f.bijective

theorem WellDefined.injPathConnectedSpace : WellDefined InjPathConnectedSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.injPathConnectedSpace h.some

end Meta

theorem isInjPathConnected_iff_injPathConnectedSpace (s : Set X) :
    IsInjPathConnected s ↔ InjPathConnectedSpace s := by
  refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
  · apply InjPathConnectedSpace.mk
    intro x y xy _ _
    obtain ⟨p, pi, ps⟩ := h (Subtype.coe_ne_coe.mpr xy) x.mem y.mem
    have (r : unitInterval) : p r ∈ s := ps ⟨r, rfl⟩
    let p' : Path x y :={
      toFun := fun r ↦ ⟨p.toFun r, ps ⟨r, rfl⟩⟩
      continuous_toFun :=
        Continuous.subtype_mk p.continuous fun x_1 ↦ id (Eq.refl (p x_1)) ▸ ps ⟨x_1, rfl⟩
      source' := by simp
      target' := by simp
    }
    refine ⟨p', ?_, subset_univ (range p')⟩
    simp only [ContinuousMap.toFun_eq_coe, Path.coe_toContinuousMap, Path.coe_mk',
      ContinuousMap.coe_mk, p']
    intro x y xy
    simp only [Subtype.mk.injEq] at xy
    exact pi xy
  · have : s = Subtype.val (p := s) '' univ := by
      rw [image_univ]
      ext x
      simp only [Subtype.range_coe_subtype, mem_setOf_eq]
      rfl
    rw [this]
    apply isInjPathConnectedSpace_of_injective_image
    · exact continuous_subtype_val
    · exact injOn_subtype_val
    · exact h.joined

end PiBase
