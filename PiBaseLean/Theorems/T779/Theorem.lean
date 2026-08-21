module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P222.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T779: P222 (HasCofiniteTopology) => P2 (T1Space) -/
instance instT1SpaceOfHasCofiniteTopology {X : Type u}
    [TopologicalSpace X] [h : HasCofiniteTopology X] :
    T1Space X where
  t1 x := isOpen_compl_iff.mp <| (h.open_iff_cofinite {x}ᶜ).2 (by simp)

end PiBase

namespace PiBase.Formal

theorem T779 : P222 ≤ P2 := fun X _ ↦ @instT1SpaceOfHasCofiniteTopology X _

end PiBase.Formal
