module

public import Mathlib.Topology.Connected.Basic
public import Mathlib.Topology.Sober
public import Mathlib.Tactic.NormNum
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P175.Bundled
public import PiBaseLean.Properties.P196.Bundled
public import PiBaseLean.Properties.P201.Bundled
public import PiBaseLean.Properties.P203.Bundled
public import PiBaseLean.Spaces.Constructions.Sierpinski.Defs

@[expose] public section

open Set Topology TopologicalSpace

namespace PiBase.SpaceConstructions

instance : Nontrivial Sierpinski := inferInstance

/-- Every Sierpiński-open set containing `False` is the whole space. -/
theorem sierpinski_open_eq_univ_of_false_mem {s : Set Sierpinski}
    (hs : IsOpen s) (hf : False ∈ s) : s = Set.univ := by
  change GenerateOpen {{True}} s at hs
  induction hs with
  | basic s hs =>
      simp only [Set.mem_singleton_iff] at hs
      subst s
      simp at hf
  | univ => rfl
  | inter s t _ _ ihs iht =>
      rw [Set.mem_inter_iff] at hf
      rw [ihs hf.1, iht hf.2, Set.univ_inter]
  | sUnion S _ ih =>
      rw [Set.mem_sUnion] at hf
      obtain ⟨t, htS, hft⟩ := hf
      apply Set.eq_univ_iff_forall.2
      intro p
      exact Set.mem_sUnion_of_mem (by simp [ih t htS hft]) htS

/-- `True` is the generic point of the canonical Sierpiński space. -/
theorem sierpinski_true_isGenericPoint :
    IsGenericPoint True (Set.univ : Set Sierpinski) := by
  rw [isGenericPoint_iff_specializes]
  intro p
  constructor
  · intro _
    trivial
  · intro _
    rw [specializes_iff_forall_open]
    intro s hs hp
    by_cases hp' : p
    · have hpeq : p = True := propext (iff_true_intro hp')
      subst p
      exact hp
    · have hfalse : p = False := propext (iff_false_intro hp')
      subst p
      rw [sierpinski_open_eq_univ_of_false_mem hs hp]
      trivial

instance : HereditarilyConnected Sierpinski where
  subset_connected s := by
    by_cases hs : s = Set.univ
    · rw [hs]
      exact sierpinski_true_isGenericPoint.isIrreducible.2.isPreconnected
    · apply Set.Subsingleton.isPreconnected
      intro p hp q hq
      apply propext
      classical
      by_contra hpq
      apply hs
      apply Set.eq_univ_iff_forall.2
      intro r
      by_cases hr : r
      · by_cases hq' : q
        · simpa [propext (iff_true_intro hr), propext (iff_true_intro hq')] using hq
        · have hp' : p := by simpa [hq'] using hpq
          simpa [propext (iff_true_intro hr), propext (iff_true_intro hp')] using hp
      · by_cases hp' : p
        · have hq' : ¬q := by simpa [hp'] using hpq
          simpa [propext (iff_false_intro hr), propext (iff_false_intro hq')] using hq
        · simpa [propext (iff_false_intro hr), propext (iff_false_intro hp')] using hp

instance : HasGenericPoint Sierpinski where
  ex_generic_point := ⟨True, sierpinski_true_isGenericPoint⟩

instance : AlmostDiscreteSpace Sierpinski where
  ex_point := ⟨False, fun p => by
    constructor
    · intro hp
      have hp' : p := by
        by_contra hnp
        exact hp (propext (iff_false_intro hnp))
      have hpeq : p = True := propext (iff_true_intro hp')
      simpa only [hpeq] using isOpen_singleton_true
    · intro hp hpfalse
      subst p
      have hu := sierpinski_open_eq_univ_of_false_mem hp (Set.mem_singleton False)
      have htrue : True ∈ ({False} : Set Prop) := by
        rw [hu]
        trivial
      simp at htrue⟩

theorem sierpinski_not_cardGeThree : ¬CardGeThree Sierpinski := by
  intro h
  have hcard := h.card_ge
  norm_num [Cardinal.mk_Prop] at hcard

end PiBase.SpaceConstructions
