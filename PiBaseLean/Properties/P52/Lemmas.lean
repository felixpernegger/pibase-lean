module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.discreteTopology [h : DiscreteTopology X] (f : X ≃ₜ Y) :
    DiscreteTopology Y :=
  f.discreteTopology

theorem WellDefined.discreteTopology : WellDefined DiscreteTopology :=
  fun {_ _} _ _ h _ ↦ Homeomorph.discreteTopology h.some

end PiBase
