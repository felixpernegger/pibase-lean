module

public import PiBaseLean.Bundled.Defs

/-! This file contains basic properties about well-defined (bundled) properties.
In particular, we show they form a complete atomic boolean algebra. -/

@[expose] public section

namespace PiBase.Formal.Property

/-- The disjunction of two properties -/
instance : Max Property where
  max p q := {
    toPred := p.toPred ⊔ q.toPred
    well_defined φ h := h.imp (p.well_defined φ) (q.well_defined φ)
  }

/-- The conjunction of two properties -/
instance : Min Property where
  min p q := {
    toPred := p.toPred ⊓ q.toPred
    well_defined φ h := h.imp (p.well_defined φ) (q.well_defined φ)
  }

/-- For two properties `p`, `q`, we write `p ≤ q`
if `p` is stronger than `q` (i.e. `p` implies `q`) -/
instance : LE Property where
  le p q := p.toPred ≤ q.toPred

/-- For two properties `p`, `q`, we write `p < q`
if `p` is strictly stronger than `q` (i.e. `p` implies `q` and `p ≠ q`) -/
instance : LT Property where
  lt p q := p.toPred < q.toPred

/-- The disjunction of a family of properties is a property. -/
instance : SupSet Property where
  sSup 𝓟 := {
    toPred := ⨆ p ∈ 𝓟, p.toPred
    well_defined φ h := by
      simp only [iSup_apply, iSup_Prop_eq, exists_prop] at h ⊢
      exact h.imp fun p ↦ And.imp_right (p.well_defined φ)
  }

/-- The conjunction of a family of properties is a property. -/
instance : InfSet Property where
  sInf 𝓟 := {
    toPred := ⨅ p ∈ 𝓟, p.toPred
    well_defined φ h := by
      simp only [iInf_apply, iInf_Prop_eq] at h ⊢
      exact forall_imp (fun p i j ↦ p.well_defined φ (i j)) h
  }

/-- The "weakest" property (which holds for all topological spaces) -/
instance : Top Property where
  top := {
    toPred := ⊤
    well_defined _ _ := trivial
  }

/-- The "strongest" property (which holds for no topological spaces) -/
instance : Bot Property where
  bot := {
    toPred := ⊥
    well_defined _ h := h.elim
  }

/-- For a property `p`, we write `pᶜ` for its negation. -/
instance : Compl Property where
  compl p := {
    toPred := p.toPredᶜ
    well_defined φ h := mt (p.well_defined φ.symm) h
  }

instance : HImp Property where
  himp p q := {
    toPred := p.toPred ⇨ q.toPred
    well_defined φ h i := q.well_defined φ (h (p.well_defined φ.symm i))
  }

instance : HNot Property where
  hnot p := {
    toPred := hnot p.toPred
    well_defined φ h := mt (p.well_defined φ.symm) h
  }

instance : SDiff Property where
  sdiff p q := {
    toPred := p.toPred \ q.toPred
    well_defined φ h := h.imp (p.well_defined φ) (mt (q.well_defined φ.symm))
  }

/-- (Well-defined) properties naturally form a complete atomatic boolean algebra -/
instance : CompleteAtomicBooleanAlgebra Property :=
  toPred_injective.completeAtomicBooleanAlgebra toPred Iff.rfl Iff.rfl
    (fun _ _ ↦ rfl) (fun _ _ ↦ rfl) (fun _ ↦ rfl) (fun _ ↦ rfl) rfl rfl
    (fun _ ↦ rfl) (fun _ _ ↦ rfl) (fun _ ↦ rfl) (fun _ _ ↦ rfl)

@[simp]
theorem compl_toPred (p : Property.{u}) : pᶜ.toPred = p.toPredᶜ := rfl

/-- Bundled-property order is implication on every topological space. -/
theorem le_iff (p q : Property.{u}) :
    p ≤ q ↔ (∀ (X : Type u) (_ : TopologicalSpace X), p.toPred X → q.toPred X) := by
  rfl

/-- Refuting an implication amounts to exhibiting a topological counterexample. -/
theorem not_le_iff (p q : Property.{u}) :
    ¬ p ≤ q ↔ (∃ (X : Type u) (_ : TopologicalSpace X), p.toPred X ∧ ¬ q.toPred X) := by
  simp [le_iff]

/-- Two bundled properties are equal when they agree on every topological space. -/
@[ext]
theorem ext
    {p q : Property.{u}} (h : ∀ (X : Type u) (_ : TopologicalSpace X), p X ↔ q X) : p = q :=
  le_antisymm
    ((le_iff p q).mp fun X _ ↦ (h X _).mp) ((le_iff q p).mp fun X _ ↦ (h X _).mpr)

end PiBase.Formal.Property
