import PibaseLean.Properties.P37.Formal
import PibaseLean.Properties.P38.Formal

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
