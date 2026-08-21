module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P36.Bundled
public import PiBaseLean.Properties.P47.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T52: P47 (TotallyDisconnectedSpace) + P125 (Nontrivial) => ¬P36 (PreconnectedSpace) -/
theorem instNotPreconnectedSpaceOfTotallyDisconnectedSpaceOfNontrivial {X : Type u}
    [TopologicalSpace X] [TotallyDisconnectedSpace X] [h : Nontrivial X] :
    ¬PreconnectedSpace X := by
  contrapose! h
  exact subsingleton_of_preconnected_totallyDisconnected

end PiBase

namespace PiBase.Formal

theorem T52 : P47 ⊓ P125 ≤ P36ᶜ :=
  fun X _ ⟨h1, h2⟩ ↦ @instNotPreconnectedSpaceOfTotallyDisconnectedSpaceOfNontrivial X _ h1 h2

end PiBase.Formal
