import Mathlib
import PibaseLean.UnstableProperties.P182.Defs

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 74. Cosmic -/
class CosmicSpace (X : Type*) [TopologicalSpace X] : Prop extends
  T3Space X, HasCountableNetwork X

end UnstablePiBase
