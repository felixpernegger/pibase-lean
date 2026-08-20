module

public import PiBaseLean.Properties.P200.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter

variable (X : Type*) [TopologicalSpace X]

/-- A nonempty, pre simply connected space is connected. -/
instance instSimplyConnectedSpaceOfPresimplyConnectedSpaceOfNonempty [h : PresimplyConnectedSpace X]
    [h' : Nonempty X] : SimplyConnectedSpace X := by
  rcases h.presimplyconnected with h|h
  · infer_instance
  · exact h

/-- A nonempty, pre simply connected space is connected. -/
example [h : PresimplyConnectedSpace X]
    [h' : Nonempty X] : SimplyConnectedSpace X := by
  rcases h.presimplyconnected with h|h
  · infer_instance
  · exact h

/-- A simply connected space is pre simply connected. -/
theorem SimplyConnectedSpace.presimplyConnectedSpace [h : SimplyConnectedSpace X] :
    PresimplyConnectedSpace X where
  presimplyconnected := .inr h

section Meta

universe u

theorem WellDefined.presimplyConnectedSpace : WellDefined PresimplyConnectedSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨h.presimplyconnected.imp ?_ ?_⟩
    · exact fun _ ↦ φ.symm.toEquiv.isEmpty
    · exact fun _ ↦ φ.symm.toHomotopyEquiv.simplyConnectedSpace

end Meta

end PiBase
