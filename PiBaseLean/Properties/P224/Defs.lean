module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P199.Defs

@[expose] public section

universe u

namespace PiBase

open Topology

/- 224. Weakly locally contractible -/
class WeaklyLocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  weakly_locally_contractible (x : X) : ∃ s ∈ 𝓝 x, ContractibleSpace s

end PiBase

namespace PiBase.Formal

def P224 : Property where
  toPred := WeaklyLocallyContractibleSpace
  well_defined φ h := sorry

end PiBase.Formal
