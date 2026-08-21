module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P201.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasGenericPoint : WellDefined HasGenericPoint :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    rcases h.ex_generic_point with ⟨x, xg⟩
    refine ⟨φ x, ?_⟩
    simp only [IsGenericPoint] at xg ⊢
    simpa [φ.image_closure] using congrArg (Set.image φ) xg

end PiBase
