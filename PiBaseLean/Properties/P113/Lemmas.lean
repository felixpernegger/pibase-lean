module

public import PiBaseLean.Properties.P110.Lemmas
public import PiBaseLean.Properties.P113.Defs

@[expose] public section

namespace PiBase

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

end PiBase
