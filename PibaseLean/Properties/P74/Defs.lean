import Mathlib
import PibaseLean.Properties.P182.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 74. Cosmic -/
class CosmicSpace (X : Type*) [TopologicalSpace X] : Prop extends
  T3Space X, HasCountableNetwork X

end PiBase
