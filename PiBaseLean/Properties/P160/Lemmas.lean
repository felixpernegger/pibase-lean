module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P160.Defs

@[expose] public section

universe u v

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open Set

/-! ### Transporting the k-Menger game along a homeomorphism

The k-Menger game is the `gFinGame` played with k-covers, so the transport machinery of
`PiBaseLean.Properties.P151.Defs` applies verbatim once we know that being a k-cover is
invariant under a homeomorphism (`preimageFamilyEquiv_isKCover'`). -/

section KMenger

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem preimageFamilyEquiv_mem_kCovers' (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    preimageFamilyEquiv φ S ∈ {A : Set (Set X) | IsKCover' A} ↔
      S ∈ {A : Set (Set Y) | IsKCover' A} :=
  preimageFamilyEquiv_isKCover' φ S

theorem kMengerGame_isPayoff_iff (φ : X ≃ₜ Y) (b : ℕ → Set (Set Y)) :
    (kMengerGame Y).IsPayoff b ↔
      (kMengerGame X).IsPayoff fun n ↦ preimageFamilyEquiv φ (b n) :=
  gFinGame_isPayoff_iff (preimageSetEquiv φ) (preimageFamilyEquiv_mem_kCovers' φ)
    (preimageFamilyEquiv_mem_kCovers' φ) b

theorem HasWinningStrategyB.kMengerGame_of_homeomorph (φ : X ≃ₜ Y)
    (h : HasWinningStrategyB (kMengerGame X)) : HasWinningStrategyB (kMengerGame Y) :=
  h.of_equiv (preimageFamilyEquiv φ) fun b hb ↦ (kMengerGame_isPayoff_iff φ b).mp hb

theorem HasMarkovKWinningStrategyB.kMengerGame_of_homeomorph {k : ℕ} (φ : X ≃ₜ Y)
    (h : HasMarkovKWinningStrategyB (kMengerGame X) k) :
    HasMarkovKWinningStrategyB (kMengerGame Y) k :=
  h.of_equiv (preimageFamilyEquiv φ) fun b hb ↦ (kMengerGame_isPayoff_iff φ b).mp hb

end KMenger

open PiBase

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.strategicallyKMengerSpace : WellDefined StrategicallyKMengerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.strategically_k_menger.kMengerGame_of_homeomorph φ⟩

end Meta

end PiBase
