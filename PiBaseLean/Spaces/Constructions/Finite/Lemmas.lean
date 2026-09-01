module

public import Mathlib.Tactic.NormNum
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P175.Bundled
public import PiBaseLean.Properties.P176.Bundled
public import PiBaseLean.Spaces.Constructions.Finite.Defs

@[expose] public section

open Cardinal

namespace PiBase.SpaceConstructions

instance : Nontrivial (FiniteDiscrete 2) := by
  rw [FiniteDiscrete]
  exact Fin.nontrivial_iff_two_le.2 (by decide)

instance : Nontrivial (FiniteIndiscrete 2) := by
  rw [FiniteIndiscrete]
  exact Fin.nontrivial_iff_two_le.2 (by decide)

instance : CardGeThree (FiniteDiscrete 3) where
  card_ge := by
    simp [FiniteDiscrete, Cardinal.mk_fintype]

theorem finiteDiscreteTwo_not_cardGeThree : ¬CardGeThree (FiniteDiscrete 2) := by
  intro h
  have hcard := h.card_ge
  norm_num [FiniteDiscrete, Cardinal.mk_fintype] at hcard

theorem finiteIndiscreteTwo_not_cardGeThree : ¬CardGeThree (FiniteIndiscrete 2) := by
  intro h
  have hcard := h.card_ge
  norm_num [FiniteIndiscrete, Cardinal.mk_fintype] at hcard

theorem finiteDiscreteThree_not_cardGeFour : ¬CardGeFour (FiniteDiscrete 3) := by
  intro h
  have hcard := h.card_ge
  norm_num [FiniteDiscrete, Cardinal.mk_fintype] at hcard

end PiBase.SpaceConstructions
