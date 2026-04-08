module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Separation.CompletelyRegular

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 54. Has a σ-locally finite basis -/
class HasSigmaLocallyFiniteBasis (X : Type u) [TopologicalSpace X] : Prop where
  ex_basis : ∃ (ι : Type u), ∃ (f : ι → Set X),
    SigmaLocallyFinite f ∧ (∀ (i : ι), IsOpen (f i)) ∧
      ∀ᵉ (x : X) (s ∈ 𝓝 x), ∃ (i : ι), x ∈ f i ∧ f i ⊆ s

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
