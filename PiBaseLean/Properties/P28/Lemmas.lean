module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P28.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.firstCountableTopology [FirstCountableTopology X] (f : X ≃ₜ Y) :
    FirstCountableTopology Y :=
  f.symm.isInducing.firstCountableTopology

theorem WellDefined.firstCountableTopology : WellDefined FirstCountableTopology :=
  fun {_ _} _ _ h _ => Homeomorph.firstCountableTopology h.some

end Meta

end PiBase
