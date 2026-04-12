module

public import PiBaseLean.Properties.P133.Defs
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

namespace PiBase

open Topology Filter Set

variable (X : Type*) [TopologicalSpace X]

section Meta

theorem Homeomorph.separableSpace [SeparableSpace X] (f : X ≃ₜ Y) : SeparableSpace Y :=
  f.symm.isOpenEmbedding.separableSpace

theorem WellDefined.separableSpace : WellDefined SeparableSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.separableSpace h.some
^
end Meta

end PiBase
