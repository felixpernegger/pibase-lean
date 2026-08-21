module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P147.Bundled
public import PiBaseLean.Properties.P90.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T350: P90 (AlexandrovDiscrete) => P147 (PSpace) -/
instance instPSpaceOfAlexandrovDiscrete {X : Type u}
    [TopologicalSpace X] [AlexandrovDiscrete X] :
    PSpace X where
  isGδ_open _ h :=
    let ⟨_, hr, _, sc⟩ := h
    sc ▸ isOpen_sInter hr

end PiBase

namespace PiBase.Formal

theorem T350 : P90 ≤ P147 := fun X _ ↦ @instPSpaceOfAlexandrovDiscrete X _

end PiBase.Formal
