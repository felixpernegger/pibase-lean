module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

universe u

theorem WellDefined.countable : WellDefined (fun (X : Type u) => Countable X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h hX => by
    have : Countable X := hX
    exact Countable.of_equiv X h.some.toEquiv

end Meta

end PiBase
