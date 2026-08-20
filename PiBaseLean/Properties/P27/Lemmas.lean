module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P27.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.secondCountableTopology [SecondCountableTopology X] (f : X ≃ₜ Y) :
    SecondCountableTopology Y :=
  f.symm.secondCountableTopology

theorem WellDefined.secondCountableTopology : WellDefined SecondCountableTopology :=
  fun {_ _} _ _ h _ => Homeomorph.secondCountableTopology h.some

end Meta

end PiBase
