import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

universe u

open Topology Filter

namespace PiBase

/- 232. LC¹ -/
class LC1 (X : Type u) [TopologicalSpace X] : Prop where
  contractible_nbhd {x : X} {N : Set X} (hN : N ∈ 𝓝 x) :
    letI x' : N := ⟨x, mem_of_mem_nhds hN⟩
    ∃ U : Set N, IsPathConnected U ∧ ∃ hU : U ∈ 𝓝 ⟨x, mem_of_mem_nhds hN⟩,
      (FundamentalGroup.map (⟨Subtype.val, continuous_subtype_val⟩ : C(U, N))
        ⟨x', mem_of_mem_nhds hU⟩).range = ⊥

end PiBase
