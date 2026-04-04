import PiBaseLean.Properties.P182.Defs
import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 74. Cosmic -/
class CosmicSpace (X : Type*) [TopologicalSpace X] : Prop extends
  T3Space X, HasCountableNetwork X

end PiBase
