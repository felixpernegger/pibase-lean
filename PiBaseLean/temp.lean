module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Separation.CompletelyRegular

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 54. Has a σ-locally finite basis -/ --TODO: Maybe make extra definition for "SigmaLocallyFinite"
class HasSigmaLocallyFiniteBasis (X : Type u) [TopologicalSpace X] : Prop where
  ex_basis : ∃ ι : Type u, Countable ι ∧ ∃ ω : ι → Type u, ∃ f : (i : ι) → (ω i) → Set X,
    (∀ i, LocallyFinite (f i)) ∧ (∀ᵉ (i : ι) (t : ω i), IsOpen (f i t)) ∧
      ∀ᵉ (x : X) (s ∈ 𝓝 x), ∃ (i : ι) (t : ω i), x ∈ f i t ∧ f i t ⊆ s

--TODO: General notion of compactification in mathlib would be cool
/-- 63. Cech complete. Note: We use the Stone Chech compactification. -/
class CechCompleteSpace (X : Type u) [TopologicalSpace X] : Prop extends T35Space X where
  is_gδ : IsGδ (range (stoneCechUnit (α := X)))

/-- 77. Corson compact -/
class CorsonCompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  homoeo_compact : ∃ α : Type u, ∃ s : Set (SigmaProduct (fun (_ : α) ↦ (0 : ℝ))),
    IsCompact s ∧ Nonempty (s ≃ₜ X)

/-- 102. Semimetrizable -/
class SemimetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty_semimetric : Nonempty (SemimetricSpace X)

/-- 104. Symmetrizable -/
class SymmetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty_symmetric : Nonempty (SymmetricSpace X)

end PiBase
