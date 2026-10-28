module

public import Mathlib
public import Mathlib.SetTheory.Cardinal.Defs
public import Mathlib.Topology.Constructions
public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P203.Bundled
public import PiBaseLean.Properties.P219.Bundled
public import PiBaseLean.Properties.P78.Bundled

@[expose] public section

universe u

open Topology Set Function Cardinal

namespace PiBase

lemma card_infinite_sdiff_point {X : Type u} [Infinite X] (p : X) :
    #(Set.univ \ {p} : Set X) = #X := by
  rw [Cardinal.mk_sdiff_eq_left_of_finite Set.infinite_univ (finite_singleton p), mk_univ]

/-- Theorem T844: P219 (TorontoSpace) ∧ P203 (AlmostDiscreteSpace) => P78 (Finite) -/
theorem instFiniteOfTorontoSpaceAndAlmostDiscreteSpace (X : Type u)
    [TopologicalSpace X] [h1 : TorontoSpace X] [h2 : AlmostDiscreteSpace X] : Finite X := by
  by_contra! h3
  obtain ⟨p, hp⟩ := h2.ex_point
  have ⟨f⟩ := h1.toronto (card_infinite_sdiff_point p)
  have h4 : DiscreteTopology (Set.univ \ {p} : Set X) := by
    simp only [discreteTopology_iff_isOpen_singleton, Subtype.forall, mem_sdiff, mem_univ,
      mem_singleton_iff, true_and]
    exact fun a ha ↦ isOpen_induced_iff.mpr ⟨{a}, (hp a).mp ha, by grind⟩
  have h5 := @Homeomorph.discreteTopology _ _ _ _ h4 f
  grind [(hp p).mpr (isOpen_discrete {p})]

end PiBase

namespace PiBase.Formal

theorem T844 : P219 ⊓ P203 ≤ P78 :=
  fun X _ ⟨h1, h2⟩ ↦ @instFiniteOfTorontoSpaceAndAlmostDiscreteSpace X _ h1 h2

end PiBase.Formal
