import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function

namespace PiBase

open PiBase.AdditionalDefs

/- 43. Locally injectively path conneced -/
class LocallyInjPathConnectedSpace (X : Type*)
    [TopologicalSpace X] : Prop where
  inj_path_connected_basis : ∀ x : X, (𝓝 x).HasBasis
    (fun s : Set X => s ∈ 𝓝 x ∧ IsInjPathConnected s) id

end PiBase

namespace PiBase.Formal

def P43 : Property where
  toPred := LocallyInjPathConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
