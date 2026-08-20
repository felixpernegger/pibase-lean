module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P107.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasClosedPoint : WellDefined HasClosedPoint :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    rcases h.has_closed_point with ⟨x, hx⟩
    refine ⟨φ x, ?_⟩
    convert φ.isClosed_image.2 hx
    simp only [image_singleton]

end Meta

end PiBase
