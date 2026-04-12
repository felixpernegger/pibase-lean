module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P37.Defs
public import PiBaseLean.Properties.P233.Defs
public import PiBaseLean.Properties.P37.Lemmas
public import PiBaseLean.Properties.P233.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T860: P37 (PrepathConnectedSpace) => P233 (HasOpenPathComponents) -/
instance instHasOpenPathComponentsOfPrepathConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : PrepathConnectedSpace X] : HasOpenPathComponents X where
  component_open x :=
    have : Nonempty X := .intro x
    PathconnectedSpace.connectedComponent_eq_univ x ▸ isOpen_univ

end PiBase

namespace PiBase.Formal

theorem T860 : P37 ≤ P233 := fun X _ ↦ @instHasOpenPathComponentsOfPrepathConnectedSpace X _

end PiBase.Formal
