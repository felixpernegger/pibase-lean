module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P125.Defs
public import PiBaseLean.Properties.P129.Defs
public import Mathlib.Logic.Nontrivial.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T247: P52 (DiscreteTopology) + P129 (IndiscreteTopology) => ¬P125 (Nontrivial) -/
instance instSubsingletonOfDiscreteTopologyOfIndiscreteTopology (X : Type u)
    [TopologicalSpace X] [DiscreteTopology X] [h : IndiscreteTopology X] : Subsingleton X := by
  refine { allEq := fun a b ↦ ?_}
  have ha : {a} = univ := by
    have := (h.isOpen_iff {a}).mp <| isOpen_discrete {a}
    simp_all
  exact (ha ▸ mem_univ b).symm

end PiBase

namespace PiBase.Formal

theorem T247 : P52 ⊓ P129 ≤ P125ᶜ :=
  fun X _ ⟨h1, h2⟩ ↦ not_nontrivial_iff_subsingleton.mpr
    (@instSubsingletonOfDiscreteTopologyOfIndiscreteTopology X _ h1 h2)

end PiBase.Formal
