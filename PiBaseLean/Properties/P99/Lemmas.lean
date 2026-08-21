module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P99.Defs

@[expose] public section

namespace PiBase

open Topology Filter

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.usSpace [h : UsSpace X] (f : X ≃ₜ Y) : UsSpace Y where
  us g a b ha hb := by
    have ha' : Tendsto (f.symm ∘ g) atTop (𝓝 (f.symm a)) :=
      (f.symm.continuous.continuousAt (x := a)).tendsto.comp ha
    have hb' : Tendsto (f.symm ∘ g) atTop (𝓝 (f.symm b)) :=
      (f.symm.continuous.continuousAt (x := b)).tendsto.comp hb
    simpa using congrArg f (h.us (f.symm ∘ g) _ _ ha' hb')

theorem WellDefined.usSpace : WellDefined UsSpace :=
  fun {_ _} _ _ h _ => Homeomorph.usSpace h.some

end PiBase
