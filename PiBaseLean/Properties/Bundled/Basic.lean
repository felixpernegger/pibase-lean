import PiBaseLean.Properties.Bundled.Defs

namespace PiBase.Formal.Property

instance : Max Property where
  max p q := {
    toPred := p.toPred ⊔ q.toPred
    well_defined' φ h := h.imp (p.well_defined' φ) (q.well_defined' φ)
  }

instance : Min Property where
  min p q := {
    toPred := p.toPred ⊓ q.toPred
    well_defined' φ h := h.imp (p.well_defined' φ) (q.well_defined' φ)
  }

instance : LE Property where
  le p q := p.toPred ≤ q.toPred

instance : LT Property where
  lt p q := p.toPred < q.toPred

instance : SupSet Property where
  sSup 𝓟 := {
    toPred := ⨆ p ∈ 𝓟, p.toPred
    well_defined' φ h := by
      simp only [iSup_apply, iSup_Prop_eq, exists_prop] at h ⊢
      exact h.imp fun p ↦ And.imp_right (p.well_defined' φ)
  }

instance : InfSet Property where
  sInf 𝓟 := {
    toPred := ⨅ p ∈ 𝓟, p.toPred
    well_defined' φ h := by
      simp only [iInf_apply, iInf_Prop_eq] at h ⊢
      exact forall_imp (fun p i j ↦ p.well_defined' φ (i j)) h
  }

instance : Top Property where
  top := {
    toPred := ⊤
    well_defined' _ _ := trivial
  }

instance : Bot Property where
  bot := {
    toPred := ⊥
    well_defined' _ h := h.elim
  }

instance : Compl Property where
  compl p := {
    toPred := p.toPredᶜ
    well_defined' φ h := mt (p.well_defined' φ.symm) h
  }

instance : HImp Property where
  himp p q := {
    toPred := p.toPred ⇨ q.toPred
    well_defined' φ h i := q.well_defined' φ (h (p.well_defined' φ.symm i))
  }

instance : HNot Property where
  hnot p := {
    toPred := hnot p.toPred
    well_defined' φ h := mt (p.well_defined' φ.symm) h
  }

instance : SDiff Property where
  sdiff p q := {
    toPred := p.toPred \ q.toPred
    well_defined' φ h := h.imp (p.well_defined' φ) (mt (q.well_defined' φ.symm))
  }

instance : CompleteAtomicBooleanAlgebra Property :=
  toPred_injective.completeAtomicBooleanAlgebra toPred Iff.rfl Iff.rfl
    (fun _ _ ↦ rfl) (fun _ _ ↦ rfl) (fun _ ↦ rfl) (fun _ ↦ rfl) rfl rfl
    (fun _ ↦ rfl) (fun _ _ ↦ rfl) (fun _ ↦ rfl) (fun _ _ ↦ rfl)

end PiBase.Formal.Property
