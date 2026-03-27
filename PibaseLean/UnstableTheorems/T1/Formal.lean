import PibaseLean.Theorems.T1.Theorem

namespace PiBase.Formal

abbrev T1 {X : Type*} [TopologicalSpace X] [CompactSpace X] :=
  CompactSpace.CountablyCompactSpace (X := X)

/-- Contrapose -/
instance T39_contra {X : Type*} [TopologicalSpace X] [h : NP19 X] : NP16 X where
  not_p16 _ := h.not_p19 (CompactSpace.CountablyCompactSpace (X := X))

end PiBase.Formal
