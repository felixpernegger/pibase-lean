module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P176.Defs

@[expose] public section

namespace PiBase

open Cardinal

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cardGeFour [h : CardGeFour X] (f : X ≃ₜ Y) : CardGeFour Y where
  card_ge := by
    refine Cardinal.lift_le.mp ?_
    rw [← Cardinal.mk_congr_lift f.toEquiv, Cardinal.lift_ofNat]
    have hx : Cardinal.lift.{v, u} (4 : Cardinal) ≤ Cardinal.lift.{v, u} #X :=
      Cardinal.lift_le.mpr h.card_ge
    simpa only [Cardinal.lift_ofNat] using hx

theorem WellDefined.cardGeFour : WellDefined fun X => CardGeFour X :=
  fun {_ _} _ _ h _ ↦ Homeomorph.cardGeFour h.some

end PiBase
