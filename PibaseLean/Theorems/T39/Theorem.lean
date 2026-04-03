import PibaseLean.Properties.P37.Defs
import PibaseLean.Properties.P38.Defs

open Topology Set Function

namespace PiBase

/- Theorem 39, injectively path connected
implies (pre-) path connected -/
instance InjPathConnectedSpace.PrePathConnectedSpace
    {X : Type*} [TopologicalSpace X] [h : InjPathConnectedSpace X] :
    PrePathConnectedSpace X where
  joined x y := (eq_or_ne x y).elim
    (fun xy => xy ▸ Joined.refl x) (fun xy => (h.joined xy).nonempty)

end PiBase

namespace PiBase.Formal

abbrev T39 {X : Type*} [TopologicalSpace X] [InjPathConnectedSpace X] :=
  InjPathConnectedSpace.PrePathConnectedSpace (X := X)

/-- Contrapose -/
instance T39_contra {X : Type*} [TopologicalSpace X] [h : NP37 X] : NP38 X where
  not_p38 _ := h.not_p37 (InjPathConnectedSpace.PrePathConnectedSpace (X := X))

end PiBase.Formal
