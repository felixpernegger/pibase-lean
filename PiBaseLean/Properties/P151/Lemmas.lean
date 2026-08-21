module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P151.Defs

@[expose] public section

universe u v

namespace PiBase

section Rothberger

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem rothbergerGame_isPayoff_iff (φ : X ≃ₜ Y) (b : ℕ → Set (Set Y)) :
    (rothbergerGame Y).IsPayoff b ↔
      (rothbergerGame X).IsPayoff fun n ↦ preimageFamilyEquiv φ (b n) :=
  g1Game_isPayoff_iff (preimageSetEquiv φ) (preimageFamilyEquiv_mem_openCovers' φ)
    (preimageFamilyEquiv_mem_openCovers' φ) b

theorem HasWinningStrategyB.rothbergerGame_of_homeomorph (φ : X ≃ₜ Y)
    (h : HasWinningStrategyB (rothbergerGame X)) : HasWinningStrategyB (rothbergerGame Y) :=
  h.of_equiv (preimageFamilyEquiv φ) fun b hb ↦ (rothbergerGame_isPayoff_iff φ b).mp hb

theorem HasMarkovKWinningStrategyB.rothbergerGame_of_homeomorph {k : ℕ} (φ : X ≃ₜ Y)
    (h : HasMarkovKWinningStrategyB (rothbergerGame X) k) :
    HasMarkovKWinningStrategyB (rothbergerGame Y) k :=
  h.of_equiv (preimageFamilyEquiv φ) fun b hb ↦ (rothbergerGame_isPayoff_iff φ b).mp hb

end Rothberger

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.strategicallyRothbergerSpace : WellDefined StrategicallyRothbergerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨fun hY ↦ (h.strategically_rothberger ⟨φ.symm hY.some⟩).rothbergerGame_of_homeomorph φ⟩

end PiBase
