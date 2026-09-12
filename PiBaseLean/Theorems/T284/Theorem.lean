module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P130.Bundled
public import PiBaseLean.Properties.P90.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T284: P90 (AlexandrovDiscrete) => P130 (LocallyCompactSpace)

The smallest open neighbourhood of a point in an Alexandrov space is compact; this is
`AlexandrovDiscrete.toLocallyCompactSpace` in Mathlib. -/
theorem instLocallyCompactSpaceOfAlexandrovDiscrete {X : Type u}
    [TopologicalSpace X] [AlexandrovDiscrete X] : LocallyCompactSpace X :=
  inferInstance

end PiBase

namespace PiBase.Formal

theorem T284 : P90 ≤ P130 := fun X _ h ↦ @instLocallyCompactSpaceOfAlexandrovDiscrete X _ h

end PiBase.Formal
