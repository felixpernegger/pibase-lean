module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P175.Defs

@[expose] public section

namespace PiBase

open Cardinal

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cardGeThree [h : CardGeThree X] (f : X ≃ₜ Y) : CardGeThree Y where
  card_ge := by
    refine Cardinal.lift_le.mp ?_
    rw [← Cardinal.mk_congr_lift f.toEquiv, Cardinal.lift_ofNat]
    have hx : Cardinal.lift.{v, u} (3 : Cardinal) ≤ Cardinal.lift.{v, u} #X :=
      Cardinal.lift_le.mpr h.card_ge
    simpa only [Cardinal.lift_ofNat] using hx

theorem WellDefined.cardGeThree : WellDefined fun X => CardGeThree X :=
  fun {_ _} _ _ h _ ↦ Homeomorph.cardGeThree h.some

end PiBase
