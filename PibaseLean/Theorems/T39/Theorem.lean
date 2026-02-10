import Mathlib
import PibaseLean.Properties.P37.Defs
import PibaseLean.Properties.P38.Defs

open Topology Set Function

namespace PiBase

/- Theorem 39, injectively path connected
implies (pre-) path connected -/
instance InjPathConnectedSpace.PrePathConnectedSpace
    (X : Type u) [TopologicalSpace X] [h : LocallyInjPathConnectedSpace X] :
    LocallyPathConnectedSpace X where
  joined x y xy := by
    obtain ⟨f, hf⟩ := h.joined x y xy
    sorry


end PiBase
