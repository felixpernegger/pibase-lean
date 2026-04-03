import PibaseLean.Properties.P74.Defs

open Topology Set Function

namespace PiBase

/- Theorem 55: a T3 space with a countable network is a cosmic space -/
instance instHasCountableNetworkOfCosmicSpace
    {X : Type*} [TopologicalSpace X] [HasCountableNetwork X] [T3Space X] :
  CosmicSpace X := by tauto

end PiBase
