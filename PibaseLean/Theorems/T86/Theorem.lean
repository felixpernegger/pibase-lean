import Mathlib
import PibaseLean.Properties.P9.Formal
import PibaseLean.Properties.P4.Formal

open Topology Set Function

namespace PiBase

/- Theorem 86, functionally hausdorff implies T25 -/
instance InjPathConnectedSpace.PrePathConnectedSpace
    (X : Type u) [TopologicalSpace X] [h : InjPathConnectedSpace X] :
    PrePathConnectedSpace X where
  joined _ _ xy :=
    Exists.intro (h.joined xy).choose ⟨(h.joined xy).choose_spec.1, (h.joined xy).choose_spec.2.2⟩

end PiBase
