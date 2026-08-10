module

public import PiBaseLean.AdditionalDefs.Cardinal
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P57.Defs
public import PiBaseLean.Properties.P136.Defs
public import PiBaseLean.Properties.P183.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T22: P136 (AnticompactSpace) + P57 (Countable) => P183 (HasCountableKNetwork) -/
instance instHasCountableKNetworkOfAnticompactSpaceOfCountable (X : Type u)
    [TopologicalSpace X] [h : AnticompactSpace X] [Countable X] : HasCountableKNetwork X where
  ex_network := by
    obtain ⟨ι, f, hι⟩ := countable_equiv_type X
    refine ⟨ι, fun i ↦ {f.symm i}, hι, ?_⟩
    unfold IsKNetwork
    intro s k hs hk ks
    simp only [iUnion_subset_iff, singleton_subset_iff]
    have : ((fun i ↦ ({f.symm i} : Set X)) ⁻¹' {{x} | x ∈ k}).Finite := by
      simp only [preimage_ofPred_eq, singleton_eq_singleton_iff, exists_eq_right]
      convert Finite.preimage (s := k) (f := f.symm) ?_ ?_
      · ext
        simp
      · apply Injective.injOn
        exact f.symm.injective
      · exact AnticompactSpace.compact_finite k hk
    use Set.Finite.toFinset this
    simp only [preimage_ofPred_eq, singleton_eq_singleton_iff, exists_eq_right, Finite.mem_toFinset,
      mem_ofPred_eq]
    refine ⟨?_, ?_⟩
    · intro i is
      simp only [mem_iUnion, mem_singleton_iff, exists_prop]
      exact ⟨f i, by simpa⟩
    · grind

end PiBase

namespace PiBase.Formal

theorem T22 : P136 ⊓ P57 ≤ P183 :=
  fun X _ ⟨h1, h2⟩ ↦ @instHasCountableKNetworkOfAnticompactSpaceOfCountable X _ h1 h2

end PiBase.Formal
