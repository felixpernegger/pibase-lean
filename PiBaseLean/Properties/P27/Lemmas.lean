module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.secondCountableTopology [SecondCountableTopology X] (f : X ≃ₜ Y) :
    SecondCountableTopology Y :=
  f.symm.secondCountableTopology

theorem WellDefined.secondCountableTopology : WellDefined SecondCountableTopology :=
  fun {_ _} _ _ h _ => Homeomorph.secondCountableTopology h.some

end PiBase
