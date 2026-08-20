module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u v

namespace PiBase

/- 69. Strategic Menger -/
class StrategicMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategic_menger : HasWinningStrategyB (mengerGame X)

end PiBase

namespace PiBase.Formal

def P69 : Property where
  toPred := StrategicMengerSpace
  well_defined {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y] (φ : X ≃ₜ Y) h :=
    ⟨h.strategic_menger.mengerGame_of_homeomorph φ⟩

end PiBase.Formal
