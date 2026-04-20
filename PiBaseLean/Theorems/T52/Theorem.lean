module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P47.Defs
public import PiBaseLean.Properties.P125.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T52: P47 (TotallyDisconnectedSpace) + P125 (Nontrivial) => ¬P36 (PreconnectedSpace) -/
theorem instNotPreconnectedSpaceOfTotallyDisconnectedSpaceOfNontrivial (X : Type u)
    [TopologicalSpace X] [TotallyDisconnectedSpace X] [h : Nontrivial X] :
    ¬PreconnectedSpace X := by
  contrapose! h
  exact subsingleton_of_preconnected_totallyDisconnected

end PiBase

namespace PiBase.Formal

theorem T52 : P47 ⊓ P125 ≤ P36ᶜ :=
  fun X _ ⟨h1, h2⟩ ↦ @instNotPreconnectedSpaceOfTotallyDisconnectedSpaceOfNontrivial X _ h1 h2

end PiBase.Formal
