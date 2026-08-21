module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P59.Defs

@[expose] public section

namespace PiBase

open Cardinal

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cardLePowerContinuum [h : CardLePowerContinuum X]
    (f : X ≃ₜ Y) : CardLePowerContinuum Y where
  card_le := by
    refine Cardinal.lift_le.mp ?_
    rw [← Cardinal.mk_congr_lift f.toEquiv, Cardinal.lift_power, Cardinal.lift_ofNat,
      Cardinal.lift_continuum]
    have hx : Cardinal.lift.{v, u} #X ≤ Cardinal.lift.{v, u} (2 ^ 𝔠) :=
      Cardinal.lift_le.mpr h.card_le
    simpa only [Cardinal.lift_power, Cardinal.lift_ofNat, Cardinal.lift_continuum] using hx

theorem WellDefined.cardLePowerContinuum :
    WellDefined (fun (X : Type u) => CardLePowerContinuum X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h _ ↦
    Homeomorph.cardLePowerContinuum (X := X) h.some

end PiBase
