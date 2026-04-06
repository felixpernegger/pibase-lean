import PiBaseLean.AdditionalDefs

universe u

open Topology PiBase.AdditionalDefs

namespace PiBase

/- 229. Semilocally simply conneced -/
class SemilocallySimplyConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  homo_trivial (x : X) : ∃ U : Set X, ∃ hU : U ∈ 𝓝 x,
    HasTrivialFundGroupImageAt ⟨Subtype.val, continuous_subtype_val⟩ ⟨x, mem_of_mem_nhds hU⟩

end PiBase
