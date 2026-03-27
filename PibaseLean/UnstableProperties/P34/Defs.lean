import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 34. Fully normal -/
class FullyNormalSpace (X : Type*) [TopologicalSpace X] : Prop
  extends ParacompactSpace X, NormalSpace X

end UnstablePiBase
