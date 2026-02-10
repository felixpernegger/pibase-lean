import PibaseLean.Theorems.T39.Theorem

namespace PiBase.Formal

abbrev T39 := InjPathConnectedSpace.PrePathConnectedSpace

/-- Contrapose -/
instance T39_contra (X : Type*) [TopologicalSpace X] [h : NP37 X] : NP38 X := by
  replace h : ¬ P37 X := h.not_p37
  exact { not_p38 := fun a ↦ h (InjPathConnectedSpace.PrePathConnectedSpace X) }

end PiBase.Formal
