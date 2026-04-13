module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P88.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.collectionwiseNormalSpace [h : CollectionwiseNormalSpace X] (f : X ≃ₜ Y) :
    CollectionwiseNormalSpace Y where
  collectionwise_normal {ι} F hF Fc := by
    sorry

theorem WellDefined.collectionwiseNormalSpace : WellDefined CollectionwiseNormalSpace := by
  intro X Y _ _ f h
  refine { collectionwise_normal := ?_ }
  intro ι F Fd Fc
  replace f := f.some
  have Fd' : IsDiscreteFamily (fun (i : ι) ↦ f ⁻¹' (F i)) := by
    intro x
    obtain ⟨s, xs, hs⟩ := Fd (f x)

    sorry
  have Fc':  (∀ (i : ι), IsClosed (⇑f ⁻¹' F i)) :=
    fun i ↦ f.isClosed_preimage.mpr (Fc i)
  have := h.collectionwise_normal (ι := ι) (fun (i : ι) ↦ f ⁻¹' (F i)) (by sorry) Fc'


  sorry


end Meta

end PiBase
