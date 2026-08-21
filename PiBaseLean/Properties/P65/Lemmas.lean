module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P65.Defs

@[expose] public section

namespace PiBase

open Cardinal

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cardEqContinuum [h : CardEqContinuum X] (f : X ≃ₜ Y) :
    CardEqContinuum Y where
  card_eq := by
    apply Cardinal.lift_injective
    rw [← Cardinal.mk_congr_lift f.toEquiv, Cardinal.lift_continuum]
    have hx : Cardinal.lift.{v, u} #X = Cardinal.lift.{v, u} 𝔠 :=
      congrArg Cardinal.lift h.card_eq
    simpa only [Cardinal.lift_continuum] using hx

theorem WellDefined.cardEqContinuum :
    WellDefined (fun (X : Type u) => CardEqContinuum X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h _ ↦
    Homeomorph.cardEqContinuum (X := X) h.some

end PiBase
