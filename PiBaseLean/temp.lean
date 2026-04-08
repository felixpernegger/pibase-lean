module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P133.Defs
public import PiBaseLean.Properties.P32.Defs
public import Mathlib.Topology.Sets.OpenCover
public import Mathlib.Topology.Separation.CompletelyRegular
public import Mathlib.SetTheory.Ordinal.Topology

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 162. Realcompact -/
class RealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  homeo_closed : ∃ (ι : Type u) (s : Set (ι → ℝ)), IsClosed s ∧ Nonempty (X ≃ₜ s)

/-- 215. Hereditarily realcompact -/
class HereditarilyRealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_realcompact (s : Set X) : RealcompactSpace s

/-- 185. Partition topology -/
class PartitionTopology (X : Type u) [TopologicalSpace X] : Prop where
  quotient_discrete : DiscreteTopology (SeparationQuotient X)

/-- 195. Stone space -/
class StoneSpace (X : Type u) [TopologicalSpace X] : Prop extends
    CompactSpace X, T2Space X, TotallyDisconnectedSpace X

open Ordinal

/-- 190. Ordinal space -/
class OrdinalSpace (X : Type u) [TopologicalSpace X] : Prop where
  homeo_ordinal : ∃ a, Nonempty (X ≃ₜ (Iio a : Set Ordinal.{u}))

/-- 183. Has a countable k-network -/
class HasCountableKNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Countable ι ∧ IsKNetwork f

/-- 174. Well-based -/
class WellBasedSpace (X : Type u) [TopologicalSpace X] : Prop where
  basis_ordered : ∀ x : X, ∃ (ι : Type u) (s : ι → Set X), (∀ i : ι, x ∈ s i) ∧
    HasBasis (𝓝 x) (fun _ ↦ True) s ∧ ∀ (i j : ι), s i ⊆ s j ∨ s j ⊆ s i

/-- 168. Countable sets are discrete -/
class CountableSetsDiscrete (X : Type u) [TopologicalSpace X] : Prop where
  countable_discrete : ∀ ⦃s : Set X⦄, s.Countable → IsDiscrete s

/-- 167. Sequentially discrete -/
class SeqDiscreteSpace (X : Type u) [TopologicalSpace X] : Prop where
  tendsto_constant : ∀ᵉ (s : ℕ → X) (x : X), Tendsto s atTop (𝓝 x) → ∀ᶠ n in atTop, s n = x



end PiBase
