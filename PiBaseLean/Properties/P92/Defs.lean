module

public import Mathlib.Order.BourbakiWitt
public import Mathlib.Topology.Separation.Hausdorff
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Set.Notation

namespace PiBase

/- 92. k ω 3 space -/
class kω3Space (X : Type*) [TopologicalSpace X] : Prop where
  k_omega : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧ (∀ n : ℕ, T2Space (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

end PiBase

namespace PiBase.Formal

def P92 : Property where
  toPred := kω3Space
  well_defined φ h := by
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

end PiBase.Formal
