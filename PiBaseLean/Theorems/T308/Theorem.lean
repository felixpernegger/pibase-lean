module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P26.Defs
public import PiBaseLean.Theorems.T308.BackgroundLemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T308:
R₀ (P135) + Has an isolated point (P139) + Nontivial (P125) => Not Connected (P26) -/
theorem instNotPreconnectedOfR0SpaceOfHasAnIsolatedPointOfNontrivial (X : Type u)
    [TopologicalSpace X] [R0Space X] [HasAnIsolatedPoint X] [h : Nontrivial X] :
    ¬ PreconnectedSpace X := by
  contrapose! h
  exact instSubsingletonOfPreconnectedSpaceOfR0SpaceOfHasAnIsolatedPoint X

end PiBase
