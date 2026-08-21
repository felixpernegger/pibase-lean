module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open Topology

namespace PiBase

/- 229. Semilocally simply connected -/
class SemilocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  homo_trivial (x : X) : ∃ U : Set X, ∃ hU : U ∈ 𝓝 x,
    HasTrivialFundGroupImageAt ⟨Subtype.val, continuous_subtype_val⟩ ⟨x, mem_of_mem_nhds hU⟩

end PiBase
