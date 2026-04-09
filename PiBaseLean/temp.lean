module

public import Mathlib
public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P68.Defs
public import PiBaseLean.Properties.P66.Defs
public import PiBaseLean.Properties.P133.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 149. ω-Lindelöf -/
class OmegaLindelof (X : Type u) [TopologicalSpace X] : Prop where
  omega_lindelof : Omega LindelofSpace X

/-- 150. ω-Rothberger -/
class OmegaRothberger (X : Type u) [TopologicalSpace X] : Prop where
  omega_rothberger : Omega RothbergerSpace X

/-- 153. ω-Rothberger -/
class OmegaMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  omega_menger : Omega MengerSpace X

/-- 154. GO-space -/
class GoSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_lots : ∃ (Z : Type u) (s : Set Z) (_ : TopologicalSpace Z),
    LOTS Z ∧ Nonempty (X ≃ₜ (↑s : Type u))

/-- 155. Locally 1-Euclidean -/
class LocallyOneEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ ℝ)

/-- 165. Pseudonormal -/
class PseudonormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  pseudonormal (s t : Set X) :
    s.Countable → IsClosed s → IsClosed t → Disjoint s t → SeparatedNhds s t

/-- 166. Has a coarser separable metrizable topology -/
class HasCoarseSepsrableMetrizableTopology (X : Type u) [τ : TopologicalSpace X] : Prop where
  ex_coarser_metrizable_separable : ∃ m : MetricSpace X,
    τ ≤ m.toUniformSpace.toTopologicalSpace ∧ @SeparableSpace X m.toUniformSpace.toTopologicalSpace

/-- 171. k₂-Hausdorff -/
class K2T2Space (X : Type u) [TopologicalSpace X] : Prop where
  closed_continuous : ∀ ⦃K : Type u⦄ {_ : TopologicalSpace K} (f : K → X × X),
    T2Space K → CompactSpace K → Continuous f → IsClosed (f ⁻¹' (diagonal X))

/-- 189. σ-connected -/
class SigmaConnectedSpace (X : Type u) [TopologicalSpace X] : Prop extends ConnectedSpace X where
  no_partition : ∀ f : ℕ → Set X, Setoid.IsPartition (range f) → ∃ n : ℕ, ¬ IsClosed (f n)

/-- 193. Shrinking -/
class ShrinkingSpace (X : Type u) [TopologicalSpace X] : Prop where
  closure_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → ⋃ a, s a = univ →
      ∃ (t : α → Set X), (∀ a, IsOpen (t a)) ∧ ⋃ a, t a = univ ∧ ∀ a, closure (t a) ⊆ s a

/-- 194. Submetacompact -/
class SubmetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_seq : ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → ⋃ a, s a = univ →
      ∃ (ω : ℕ → Type u) (t : (n : ℕ) → ω n → Set X), (∀ n : ℕ, (∀ (a : ω n), IsOpen (t n a)) ∧
        ⋃ a, t n a = univ ∧ ∀ (b : ω n), ∃ (a : α), t n b ⊆ s a) ∧ ∀ x, ∃ n, PointFiniteAt (t n) x

open Cardinal

/-- 197. Has countable spread -/
class HasCountableSpread (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Spread X = ℵ₀

/-- 197. Has countable extent -/
class HasCountableExtent (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Extent X = ℵ₀

/-- 172. Radial -/ --TODO: Maybe define via "radically closed" set
class RadialSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_seq (A : Set X) : ∀ x ∈ closure A, ∃ (s : Ordinal.{u}) (f : Iio s → X), Tendsto f atTop (𝓝 x)

end PiBase
