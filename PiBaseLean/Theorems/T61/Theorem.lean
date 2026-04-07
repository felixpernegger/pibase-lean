module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P74.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

/- Theorem 61: a T3 space with a countable network is a cosmic space -/
instance instHasCountableNetworkOfCosmicSpace
    {X : Type*} [TopologicalSpace X] [HasCountableNetwork X] [T3Space X] :
  CosmicSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T61 : P182 ⊓ P5 ≤ P74 := fun X _ ↦ and_imp.2
  (@instHasCountableNetworkOfCosmicSpace X _)

end PiBase.Formal
