import PibaseLean.Properties.P22.Defs
import PibaseLean.Properties.P19.Defs
import Mathlib

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem 4, countably compact implies PseudocompactSpace -/
instance CountablyCompactSpace.PseudocompactSpaceSpace
    {X : Type*} [TopologicalSpace X] [h : CountablyCompactSpace X] :
    PseudocompactSpace X where
  pseudocompact := by
    intro f hf
    apply?
    --apply?
    sorry


end PiBase
