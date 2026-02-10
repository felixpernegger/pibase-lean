import PibaseLean.Theorems.T39.Theorem

namespace PiBase.Formal

abbrev T39 := InjPathConnectedSpace.PrePathConnectedSpace

/-- Contrapose -/
instance T39_contra (X : Type*) [TopologicalSpace X] [h : NP37 X] : NP38 X := by
  have h : ¬ P37 X := h.not_p37
  contrapose! h
  sorry

end PiBase.Formal
