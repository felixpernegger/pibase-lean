import Mathlib
import PibaseLean.UnstableProperties.P34.Defs

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 35. Fully T₄ -/
class FullyT4Space (X : Type*) [TopologicalSpace X] : Prop extends T1Space X, FullyNormalSpace X

end UnstablePiBase
