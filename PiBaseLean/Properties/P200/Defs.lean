import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected

universe u
namespace PiBase

/- 200. Simply connected -/
class PreSimplyConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  presimplyconnected : IsEmpty X ∨ SimplyConnectedSpace X

end PiBase
