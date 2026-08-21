module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P69.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.strategicMengerSpace : WellDefined StrategicMengerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.strategic_menger.mengerGame_of_homeomorph φ⟩

end PiBase
