module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology

namespace PiBase

/- 229. Semilocally simply conneced -/
class SemilocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  homo_trivial (x : X) : ∃ U : Set X, ∃ hU : U ∈ 𝓝 x,
    HasTrivialFundGroupImageAt ⟨Subtype.val, continuous_subtype_val⟩ ⟨x, mem_of_mem_nhds hU⟩

end PiBase

namespace PiBase.Formal

def P229 : Property where
  toPred := SemilocallySimplyConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
