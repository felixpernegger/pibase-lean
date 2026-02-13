import PibaseLean.Theorems.T39.Theorem

namespace PiBase.Formal

abbrev T39 {X : Type*} [TopologicalSpace X] [InjPathConnectedSpace X] :=
  InjPathConnectedSpace.PrePathConnectedSpace (X := X)

/-- Contrapose -/
instance T39_contra {X : Type*} [TopologicalSpace X] [h : NP37 X] : NP38 X where
  not_p38 _ := h.not_p37 (InjPathConnectedSpace.PrePathConnectedSpace (X := X))

end PiBase.Formal
