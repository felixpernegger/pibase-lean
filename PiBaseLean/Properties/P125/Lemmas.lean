module

public import PiBaseLean.Properties.P125.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.nontrivial [Nontrivial X] (f : X ≃ₜ Y) : Nontrivial Y :=
  f.toEquiv.nontrivial_congr.mp ‹_›

theorem WellDefined.nontrivial : WellDefined (fun X => Nontrivial X) :=
  fun {_ _} _ _ h _ ↦ Homeomorph.nontrivial h.some

end PiBase
