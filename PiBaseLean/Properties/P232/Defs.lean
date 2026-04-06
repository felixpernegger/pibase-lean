import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

open Topology Filter PiBase.AdditionalDefs

namespace PiBase

/- 232. LC¹ -/ --TODO: Maybe later define LC^n in general with homotopy groups
class LC1 (X : Type*) [TopologicalSpace X] : Prop where
  contractible_nbhd {x : X} {N : Set X} (hN : N ∈ 𝓝 x) :
    letI x' : N := ⟨x, mem_of_mem_nhds hN⟩
    ∃ U : Set N, IsPathConnected U ∧ ∃ hU : U ∈ 𝓝 ⟨x, mem_of_mem_nhds hN⟩,
      HasTrivialFundGroupImageAt ⟨Subtype.val, continuous_subtype_val⟩ ⟨x', mem_of_mem_nhds hU⟩

end PiBase

namespace PiBase.Formal

def P232 : Property where
  toPred := LC1
  well_defined' φ h := sorry

end PiBase.Formal
