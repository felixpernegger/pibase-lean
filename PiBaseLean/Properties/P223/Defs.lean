module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P199.Defs

@[expose] public section

universe u

namespace PiBase

open Topology Filter

/- 223. Locally contractible -/
class LocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_contractible (x : X) : (𝓝 x).HasBasis
    (fun (s : Set X) ↦ IsOpen s ∧ x ∈ s ∧ ContractibleSpace s) id

end PiBase

namespace PiBase.Formal

def P223 : Property where
  toPred := LocallyContractibleSpace
  well_defined φ h := sorry

end PiBase.Formal
