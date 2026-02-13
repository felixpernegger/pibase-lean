import PibaseLean.Theorems.T1.Theorem

namespace PiBase.Formal

abbrev T1 := CompactSpace.CountablyCompactSpace

/-- Contrapose -/
instance T39_contra {X : Type*} [TopologicalSpace X] [h : NP16 X] : NP19 X where
  not_p19 := fun a ↦ h.not_p16 (CompactSpace.CountablyCompactSpace)

end PiBase.Formal
