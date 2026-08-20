module

public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P47.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.totallyDisconnectedSpace [h : TotallyDisconnectedSpace X]
    (f : X ≃ₜ Y) : TotallyDisconnectedSpace Y :=
  f.totallyDisconnectedSpace

theorem WellDefined.totallyDisconnectedSpace : WellDefined TotallyDisconnectedSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.totallyDisconnectedSpace h.some

end Meta

end PiBase
