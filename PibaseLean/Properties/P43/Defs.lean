import Mathlib
import PibaseLean.Properties.P38.Defs

open Topology Set Function

namespace PiBase

/- 43. Locally injectively path conneced -/
class LocallyInjPathConnectedSpace (X : Type*)
    [TopologicalSpace X] : Prop where
  joined : ∀ x : X, ∃ s ∈ 𝓝 x, InjPathConnectedSpace s

end PiBase
