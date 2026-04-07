import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import PiBaseLean.Properties.Bundled.Defs

open Topology

namespace PiBase

/- 230. Locally simply connected -/
class LocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_basis (x : X) :
    (𝓝 x).HasBasis (fun s : Set X => x ∈ s ∧ IsOpen s ∧ SimplyConnectedSpace s) id

end PiBase

namespace PiBase.Formal

def P230 : Property where
  toPred := LocallySimplyConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
