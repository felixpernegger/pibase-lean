module

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
    [TopologicalSpace X] [AnticompactSpace X] [Countable X] : HasCountableKNetwork X where
  ex_network := by
    obtain ⟨ι, f, hι⟩ := countable_equiv_type X
    refine ⟨ι, fun i ↦ {f.symm i}, hι, ?_⟩
    unfold IsKNetwork
    intro s k _ _ ks
    use (fun i ↦ ({f.symm i} : Set X)) ⁻¹' {{x } | x ∈ s}
    simp only [preimage_setOf_eq, singleton_eq_singleton_iff, exists_eq_right, mem_setOf_eq,
      iUnion_subset_iff, singleton_subset_iff, imp_self, implies_true, and_true]
    apply subset_trans ks
    intro i is
    simp only [mem_iUnion, mem_singleton_iff, exists_prop]
    exact ⟨f i, by simpa⟩

end PiBase

namespace PiBase.Formal

theorem T22 : P136 ⊓ P57 ≤ P183 := fun X _ ⟨h1, h2⟩ ↦ @instHasCountableKNetworkOfAnticompactSpaceOfCountable X _ h1 h2

end PiBase.Formal
