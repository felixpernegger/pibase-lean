import PibaseLean.Properties.P74.Defs

open Topology Set Function

namespace PiBase

/- Theorem 61: a Cosmic space has a countable network -/
instance instHasCountableNetworkOfCosmisSpace {X : Type*} [TopologicalSpace X] [CosmicSpace X] :
    HasCountableNetwork X := by infer_instance

end PiBase
