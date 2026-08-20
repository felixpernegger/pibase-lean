module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P113.Defs
public import PiBaseLean.Properties.P110.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.mooreSpace : WellDefined MooreSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have hDev := h.toDevelopableSpace
    have hDevY := WellDefined.developableSpace.homeo φ hDev
    have hT3 := h.toT3Space
    have := hT3
    have hT3Y := φ.t3Space
    exact { toDevelopableSpace := hDevY, toT3Space := hT3Y }

end Meta

end PiBase
