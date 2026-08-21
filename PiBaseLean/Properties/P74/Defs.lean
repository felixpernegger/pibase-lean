module

public import PiBaseLean.Properties.P182.Defs
public import PiBaseLean.Properties.P5.Defs

@[expose] public section

universe u

namespace PiBase

/- 74. Cosmic -/
class CosmicSpace (X : Type*) [TopologicalSpace X] : Prop extends
  T3Space X, HasCountableNetwork X

end PiBase
