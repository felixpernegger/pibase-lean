module

public import PiBaseLean.AdditionalDefs.Constructions
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.AlgebraicTopology.FundamentalGroupoid.Basic
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

open Topology Set Filter

namespace PiBase

/- 232. LC¹ -/ --TODO: Maybe later define LC^n in general with homotopy groups
class LC1 (X : Type*) [TopologicalSpace X] : Prop where
  contractible_nbhd {x : X} {N : Set X} (hN : N ∈ 𝓝 x) :
    ∃ U : Set N, IsPathConnected U ∧ ∃ hU : U ∈ 𝓝 ⟨x, mem_of_mem_nhds hN⟩,
      HasTrivialFundGroupImageAt (⟨Subtype.val, continuous_subtype_val⟩ : C(↥U, ↥N))
        ⟨⟨x, mem_of_mem_nhds hN⟩, mem_of_mem_nhds hU⟩

end PiBase
