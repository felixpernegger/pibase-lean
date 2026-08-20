module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P78.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

universe u

theorem WellDefined.finite : WellDefined (fun (X : Type u) => Finite X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h hX => by
    have : Finite X := hX
    exact Finite.of_equiv X h.some.toEquiv

end Meta

end PiBase
