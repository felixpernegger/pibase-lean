module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P92.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.kω3Space : WellDefined kω3Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨K, hMono, hUniv, hComp, hT2, hOpen⟩ := h.k_omega
    refine ⟨⟨fun n => φ '' K n, ?_, ?_, fun n => (hComp n).image φ.continuous, ?_, ?_⟩⟩
    · intro a b hab
      exact Set.image_mono (hMono hab)
    · calc
        univ = φ '' univ := by rw [image_univ, EquivLike.range_eq_univ]
        _ = φ '' (⋃ n, K n) := by rw [← hUniv]
        _ = ⋃ n, φ '' K n := by rw [image_iUnion]
    · intro n
      have : T2Space (K n) := hT2 n
      exact (φ.image (K n)).t2Space
    · intro s
      constructor
      · intro hs n
        exact (φ.image (K n)).isOpen_preimage.mp <|
          (hOpen _).mp (φ.isOpen_preimage.mpr hs) n
      · intro hs
        exact φ.isOpen_preimage.mp <| (hOpen _).mpr fun n =>
          (φ.image (K n)).isOpen_preimage.mpr (hs n)

end PiBase
