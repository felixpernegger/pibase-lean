import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

universe u

open Topology

namespace PiBase

/- 229. Semilocally simply conneced -/
class SemilocallySimplyConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  homo_trivial (x : X) : ∃ U : Set X, ∃ hU : U ∈ 𝓝 x,
    (FundamentalGroup.map (⟨Subtype.val, continuous_subtype_val⟩ : C(U, X))
      ⟨x, mem_of_mem_nhds hU⟩).range = ⊥

end PiBase
