import PiBaseLean.Properties.P16.Defs
import PiBaseLean.Properties.P19.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

-- Note: Is merged in mathlib
/- Theorem 1, compact implies compactly compact -/
instance instCompactSpaceOfCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [h : CompactSpace X] :
    CountablyCompactSpace X where
  isCountablyCompact_univ := isCompact_univ.isCountablyCompact

end PiBase

namespace PiBase.Formal

abbrev T1 {X : Type*} [TopologicalSpace X] [CompactSpace X] :=
  instCompactSpaceOfCountablyCompactSpace (X := X)

/-- Contrapose -/
instance T1_contra {X : Type*} [TopologicalSpace X] [h : NP19 X] : NP16 X where
  not_p16 _ := h.not_p19 (instCompactSpaceOfCountablyCompactSpace (X := X))

end PiBase.Formal
