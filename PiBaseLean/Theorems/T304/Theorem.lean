module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P136.Bundled
public import PiBaseLean.Properties.P17.Bundled
public import PiBaseLean.Properties.P57.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

/-- Theorem T304: P136 (AnticompactSpace) + P17 (SigmaCompactSpace) => P57 (Countable) -/
instance instCountableOfAnticompactSpaceOfSigmaCompactSpace {X : Type u}
    [TopologicalSpace X] [h : AnticompactSpace X] [h' : SigmaCompactSpace X] :
    Countable X := by
  obtain ⟨S, Sc, hS⟩ := h'.isSigmaCompact_univ
  apply countable_univ_iff.mp
  exact hS ▸ countable_iUnion fun i ↦ (h.compact_finite (S i) (Sc i)).countable

end PiBase

namespace PiBase.Formal

theorem T304 : P136 ⊓ P17 ≤ P57 :=
  fun X _ ⟨h1, h2⟩ ↦ @instCountableOfAnticompactSpaceOfSigmaCompactSpace X _ h1 h2

end PiBase.Formal
