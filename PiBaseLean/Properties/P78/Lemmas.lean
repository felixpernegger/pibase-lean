module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

universe u

theorem WellDefined.finite : WellDefined (fun (X : Type u) => Finite X) :=
  fun {X Y} [TopologicalSpace X] [TopologicalSpace Y] h hX => by
    have : Finite X := hX
    exact Finite.of_equiv X h.some.toEquiv

end PiBase
