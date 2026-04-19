module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P51.Lemmas
public import PiBaseLean.Properties.P73.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T865: P51 (ScatteredSpace) => P73 (SoberSpace) -/
instance instSoberSpaceOfScatteredSpace (X : Type u)
    [TopologicalSpace X] [h : ScatteredSpace X] : SoberSpace X := by
  refine soberSpace_iff_ex_unique_generic.mpr (fun S Si Sc ↦ ?_)
  obtain ⟨⟨p, pS⟩, hp⟩ := h.scattered S (IsIrreducible.nonempty Si)
  obtain ⟨U, Uo, hU⟩ := hp
  have pU : p ∈ U := by
    simpa using Set.ext_iff.mp hU ⟨p, pS⟩
  refine ⟨p, ?_, ?_⟩
  · apply subset_antisymm <| (IsClosed.mem_iff_closure_subset Sc).mp pS
    intro y yS
    unfold IsIrreducible IsPreirreducible at Si
    contrapose! Si
    intro _
    refine ⟨U, (closure {p})ᶜ, Uo, ?_, ?_, ?_, ?_⟩
    · exact isOpen_compl_iff.mpr isClosed_closure
    · refine ⟨p, pS, ?_⟩
      simpa using Set.ext_iff.mp hU ⟨p, pS⟩
    · exact ⟨y, yS, (mem_compl_iff (closure {p}) y).mpr Si⟩
    ext z
    simp only [mem_inter_iff, mem_compl_iff, mem_empty_iff_false, iff_false, not_and, not_not]
    intro zS zU
    have : ⟨z, zS⟩ ∈ Subtype.val ⁻¹' U := mem_preimage.mpr zU
    rw [hU] at this
    simp only [mem_singleton_iff, Subtype.mk.injEq] at this
    exact subset_closure <| mem_singleton_of_eq this
  intro y hy
  by_contra h0
  have pc : p ∈ Uᶜ := by
    apply (Set.ext_iff.mp hy p).mpr pS Uᶜ ⟨Uo.isClosed_compl, ?_⟩
    simpa [h0] using Set.ext_iff.mp hU ⟨y, hy.mem⟩
  exact pc pU

end PiBase

namespace PiBase.Formal

theorem T865 : P51 ≤ P73 := fun X _ ↦ @instSoberSpaceOfScatteredSpace X _

end PiBase.Formal
