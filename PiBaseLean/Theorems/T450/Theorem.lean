module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P27.Defs
public import PiBaseLean.Properties.P129.Defs
public import Mathlib.Topology.Bases

@[expose] public section

universe u

open Topology Set Function TopologicalSpace Filter

namespace PiBase

/-- Theorem T450: P129 (IndiscreteTopology) => P27 (SecondCountableTopology) -/
instance instSecondCountableTopologyOfIndiscreteTopology (X : Type u)
    [TopologicalSpace X] [IndiscreteTopology X] : SecondCountableTopology X := by
  refine IsTopologicalBasis.secondCountableTopology (b := {univ}) ?_ (countable_singleton univ)
  apply IsTopologicalBasis.of_hasBasis_nhds
  intro
  apply hasBasis_iff.mpr
  intro
  simp only [mem_singleton_iff, id_eq, ↓existsAndEq, mem_univ, and_self, univ_subset_iff, true_and]
  refine ⟨fun h ↦ ?_, fun h ↦ h.symm ▸ univ_mem⟩
  rw [IndiscreteTopology.nhds_eq] at h
  simp_all

end PiBase

namespace PiBase.Formal

theorem T450 : P129 ≤ P27 := fun X _ ↦ @instSecondCountableTopologyOfIndiscreteTopology X _

end PiBase.Formal
