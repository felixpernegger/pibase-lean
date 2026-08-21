module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P163.Defs

@[expose] public section

namespace PiBase

open Cardinal

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cardLeContinuum [h : CardLeContinuum X] (f : X ≃ₜ Y) :
    CardLeContinuum Y where
  card_le := by
    refine Cardinal.lift_le.mp ?_
    rw [← Cardinal.mk_congr_lift f.toEquiv, Cardinal.lift_continuum]
    have hx : Cardinal.lift.{v, u} #X ≤ Cardinal.lift.{v, u} 𝔠 :=
      Cardinal.lift_le.mpr h.card_le
    simpa only [Cardinal.lift_continuum] using hx

theorem WellDefined.cardLeContinuum :
    WellDefined (fun (X : Type u) => CardLeContinuum X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h _ ↦
    Homeomorph.cardLeContinuum (X := X) h.some

end PiBase
