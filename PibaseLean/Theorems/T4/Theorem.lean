import PibaseLean.Properties.P22.Defs
import PibaseLean.Properties.P19.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem 4, countably compact implies PseudocompactSpace -/
instance CountablyCompactSpace.PseudocompactSpaceSpace
    {X : Type*} [TopologicalSpace X] [h : CountablyCompactSpace X] :
    PseudocompactSpaceSpace X where
  isCountablyCompact_univ := by
    sorry


end PiBase
