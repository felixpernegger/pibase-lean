import Mathlib
import PibaseLean.Properties.P37.Formal
import PibaseLean.Properties.P38.Formal

open Topology Set Function

namespace PiBase

/- Theorem 39, injectively path connected
implies (pre-) path connected -/
instance InjPathConnectedSpace.PrePathConnectedSpace
    (X : Type*) [TopologicalSpace X] [h : InjPathConnectedSpace X] :
    PrePathConnectedSpace X where
  joined _ _ xy :=
    Exists.intro (h.joined xy).choose ⟨(h.joined xy).choose_spec.1, (h.joined xy).choose_spec.2.2⟩

end PiBase
