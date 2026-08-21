module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P16.Bundled
public import PiBaseLean.Properties.P18.Bundled
public import PiBaseLean.Properties.P19.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T106: P18 (LindelofSpace) + P19 (CountablyCompactSpace) => P16 (CompactSpace) -/
theorem instCompactSpaceOfLindelofSpaceOfCountablyCompactSpace {X : Type u}
    [TopologicalSpace X] [LindelofSpace X] [h : CountablyCompactSpace X] : CompactSpace X where
  isCompact_univ := isLindelof_univ.isCompact h.isCountablyCompact_univ

end PiBase

namespace PiBase.Formal

theorem T106 : P18 ⊓ P19 ≤ P16 :=
  fun X _ ⟨h1, h2⟩ ↦ @instCompactSpaceOfLindelofSpaceOfCountablyCompactSpace X _ h1 h2

end PiBase.Formal
