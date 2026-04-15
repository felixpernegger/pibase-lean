module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P17.Defs
public import PiBaseLean.Properties.P57.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T74: P57 (Countable) => P17 (SigmaCompactSpace) -/
instance instSigmaCompactSpaceOfCountable (X : Type u)
    [TopologicalSpace X] [h : Countable X] : SigmaCompactSpace X := by
  by_cases! IsEmpty X
  · infer_instance
  apply SigmaCompactSpace_iff_exists_compact_covering.mpr
  obtain ⟨f, hf⟩ := (countable_iff_exists_surjective (α := X)).mp h
  refine ⟨fun n ↦ {f n}, ?_, ?_⟩
  · simp
  ext n
  simp only [iUnion_singleton_eq_range, mem_range, mem_univ, iff_true]
  exact mem_range.mp (hf n)

end PiBase

namespace PiBase.Formal

theorem T74 : P57 ≤ P17 := fun X _ ↦ @instSigmaCompactSpaceOfCountable X _

end PiBase.Formal
