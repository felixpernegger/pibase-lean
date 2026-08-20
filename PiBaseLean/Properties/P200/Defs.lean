module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected

@[expose] public section

namespace PiBase

/- 200. Simply connected -/
class PresimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  presimplyconnected : IsEmpty X ∨ SimplyConnectedSpace X

end PiBase
