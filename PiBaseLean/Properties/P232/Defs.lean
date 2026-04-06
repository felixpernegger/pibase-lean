import PiBaseLean.AdditionalDefs

universe u

open Topology Filter PiBase.AdditionalDefs

namespace PiBase

/- 232. LC¹ -/
class LC1 (X : Type u) [TopologicalSpace X] : Prop where
  contractible_nbhd {x : X} {N : Set X} (hN : N ∈ 𝓝 x) :
    letI x' : N := ⟨x, mem_of_mem_nhds hN⟩
    ∃ U : Set N, IsPathConnected U ∧ ∃ hU : U ∈ 𝓝 ⟨x, mem_of_mem_nhds hN⟩,
      HasTrivialFundGroupImageAt (⟨Subtype.val, continuous_subtype_val⟩ : C(U, N))
        ⟨x', mem_of_mem_nhds hU⟩

end PiBase
