module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P133.Defs
public import PiBaseLean.Properties.P32.Defs
public import Mathlib.Topology.Sets.OpenCover
public import Mathlib.Topology.Separation.CompletelyRegular

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 54. Has a σ-locally finite basis -/
class HasSigmaLocallyFiniteBasis (X : Type u) [TopologicalSpace X] : Prop where
  ex_basis : ∃ (ι : Type u), ∃ (f : ι → Set X),
    Sigma LocallyFinite f ∧ (∀ (i : ι), IsOpen (f i)) ∧
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

/-- 115. Subparacompact -/
class SubparacompactlSpace (X : Type u) [TopologicalSpace X] : Prop where
  locallyFinite_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsClosed (t b)) ∧ (⋃ b, t b = univ) ∧ Sigma LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-- 120. Locally orderable -/
class LocallyOrderableSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_nbhd_lots (x : X) : ∃ s ∈ 𝓝 x, LOTS s

/-- 122. Locally Euclidean -/
class LocallyEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X) : ∃ n : ℕ, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ (Fin n → ℝ))

/-- 123. Locally n-Euclidean -/
class LocallyNEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∃ n : ℕ, ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ (Fin n → ℝ))

/-- 124. Topological n-manifold -/
class TopologicalNManifold (X : Type u) [TopologicalSpace X] : Prop extends
  LocallyNEuclideanSpace X, T2Space X, SecondCountableTopology X

/-- 126. Door -/
class DoorSpace (X : Type u) [TopologicalSpace X] : Prop where
  isOpen_or_isClosed (s : Set X) : IsOpen s ∨ IsClosed s

/-- 127. Dowker -/
class DowkerSpace (X : Type u) [TopologicalSpace X] : Prop extends T4Space X where
  not_countably_paracompact : ¬ CountablyParacompactSpace X

/-- k-Lindelöf -/
class OmegaLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_kSubcover {ι : Type u} {f : ι → Set X} (h : IsKCover f) : True

end PiBase
