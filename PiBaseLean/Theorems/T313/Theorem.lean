module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P29.Bundled
public import PiBaseLean.Properties.P39.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T313: P39 ≤ P29

A hyperconnected space has no two disjoint nonempty open sets, so a pairwise disjoint family
of open sets has at most one nonempty member and is therefore countable. -/
theorem instCountableChainConditionOfPreirreducibleSpace [h : PreirreducibleSpace X] :
    CountableChainCondition X := by
  refine ⟨fun S hdisj hopen ↦ ?_⟩
  have hsub : S ⊆ insert ∅ {s ∈ S | s.Nonempty} := fun s hs ↦ by
    rcases eq_empty_or_nonempty s with rfl | hne
    · exact mem_insert _ _
    · exact mem_insert_of_mem _ ⟨hs, hne⟩
  refine Set.Countable.mono hsub (Set.Countable.insert _ (Set.Subsingleton.countable ?_))
  rintro a ⟨haS, ha⟩ b ⟨hbS, hb⟩
  by_contra hab
  obtain ⟨z, _, hz⟩ := h.isPreirreducible_univ a b (hopen a haS) (hopen b hbS)
    ⟨ha.some, trivial, ha.some_mem⟩ ⟨hb.some, trivial, hb.some_mem⟩
  exact (Set.disjoint_left.1 (hdisj haS hbS hab)) hz.1 hz.2

end PiBase

namespace PiBase.Formal

theorem T313 : P39 ≤ P29 := fun X _ h ↦ @instCountableChainConditionOfPreirreducibleSpace X _ h

end PiBase.Formal
