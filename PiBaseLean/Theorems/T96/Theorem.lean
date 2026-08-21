module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P39.Bundled
public import PiBaseLean.Properties.P49.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T96: P39 (PreirreducibleSpace) => P49 (ExtremallyDisconnected) -/
instance instExtremallyDisconnectedOfPreirreducibleSpace {X : Type u}
    [TopologicalSpace X] [h : PreirreducibleSpace X] : ExtremallyDisconnected X where
  open_closure U hU := by
    by_cases! Un : U = ∅
    · simp_all
    · exact ((preirreducibleSpace_iff_open_dense X).mp h hU Un).closure_eq ▸ isOpen_univ

end PiBase

namespace PiBase.Formal

theorem T96 : P39 ≤ P49 := fun X _ ↦ @instExtremallyDisconnectedOfPreirreducibleSpace X _

end PiBase.Formal
