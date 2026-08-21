module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P58.Defs

@[expose] public section

namespace PiBase

open Cardinal

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cardLtContinuum [h : CardLtContinuum X] (f : X ≃ₜ Y) :
    CardLtContinuum Y where
  card_lt := by
    refine Cardinal.lift_lt.mp ?_
    rw [← Cardinal.mk_congr_lift f.toEquiv, Cardinal.lift_continuum]
    have hx : Cardinal.lift.{v, u} #X < Cardinal.lift.{v, u} 𝔠 :=
      Cardinal.lift_lt.mpr h.card_lt
    simpa only [Cardinal.lift_continuum] using hx

theorem WellDefined.cardLtContinuum :
    WellDefined (fun (X : Type u) => CardLtContinuum X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h _ ↦
    Homeomorph.cardLtContinuum (X := X) h.some

end PiBase
