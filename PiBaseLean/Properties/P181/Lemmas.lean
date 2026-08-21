module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P181.Defs

@[expose] public section

namespace PiBase

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.countablyInfinite [h : CountablyInfinite X] (f : X ≃ₜ Y) :
    CountablyInfinite Y where
  toCountable := .of_equiv _ f.toEquiv
  toInfinite := (Equiv.infinite_iff f.toEquiv).1 h.toInfinite

theorem WellDefined.countablyInfinite : WellDefined fun X => CountablyInfinite X :=
  fun {_ _} _ _ h _ ↦ Homeomorph.countablyInfinite h.some

end PiBase
