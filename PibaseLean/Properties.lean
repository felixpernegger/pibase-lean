import Mathlib

universe u v

variable {X : Type*} {Y : Type*} [TopologicalSpace X]

#check TopologicalSpace

open Function Set Filter Topology TopologicalSpace

/-T₀-/
class P1 (X : Type u) [TopologicalSpace X] : Prop where
  p1 : T0Space X

/-T₁-/
class P2 (X : Type u) [TopologicalSpace X] : Prop where
  p2 : T1Space X

/-T₂-/
class P3 (X : Type u) [TopologicalSpace X] : Prop where
  p3 : T2Space X

/-T25-/
class P4 (X : Type u) [TopologicalSpace X] : Prop where
  p4 : Pairwise fun (x y : X) ↦ ∃ u ∈ 𝓝 x, ∃ v ∈ 𝓝 y, IsClosed u ∧ IsClosed v ∧ Disjoint u v

/-Regular-/
class P11 (X : Type u) [TopologicalSpace X] : Prop where
  p11 : RegularSpace X

/-Completely regular-/
class P12 (X : Type u) [TopologicalSpace X] : Prop where
  p12 : CompletelyRegularSpace X

/-T₃-/
class P5 (X : Type u) [TopologicalSpace X] : Prop extends P11 X, P1 X

/-T35-/
class P6 (X : Type u) [TopologicalSpace X] : Prop extends P12 X, P1 X

/-T₄-/
class P7 (X : Type u) [TopologicalSpace X] : Prop where
  p7 : T4Space X

/-T₅-/
class P8 (X : Type u) [TopologicalSpace X] : Prop where
  p8 : T5Space X

/-Functionally Hausdorff-/
class P9 (X : Type u) [TopologicalSpace X] : Prop where
  p9 : Pairwise fun (x y : X) ↦ ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

/-Semiregular-/
class P10 (X : Type u) [TopologicalSpace X] : Prop where
  p10 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

#check P11

#check P12

/-Normal-/
class P13 (X : Type u) [TopologicalSpace X] : Prop where
  p13 : NormalSpace X

/-Completely normal-/
class P14 (X : Type u) [TopologicalSpace X] : Prop where
  p14 : CompletelyNormalSpace X

/-Perfectly normal-/
class P15 (X : Type u) [TopologicalSpace X] : Prop where
  p15 : PerfectlyNormalSpace X

/-Compact-/
class P16 (X : Type u) [TopologicalSpace X] : Prop where
  p16 : CompactSpace X

/-σ-compact-/
class P17 (X : Type u) [TopologicalSpace X] : Prop where
  p17 : SigmaCompactSpace X

/-Lindelöf-/
class P18 (X : Type u) [TopologicalSpace X] : Prop where
  p18 : LindelofSpace X

/-Countably compact-/
class P19 (X : Type u) [TopologicalSpace X] : Prop where
  p19 : ∀ {ι : Type v} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (X = ⋃ i, U i) → ∃ t : Set ι, Countable t ∧ X = ⋃ i ∈ t, U i

/-Sequentially compact-/
class P20 (X : Type u) [TopologicalSpace X] : Prop where
  p20 : SeqCompactSpace X

/-Weakly countably compact-/
class P21 (X : Type u) [TopologicalSpace X] : Prop where
  p21 : ∀ Y : Set X, ¬ Finite Y → ∃ x : X, ∀ s ∈ 𝓝 x, (s ∩ Yᶜ).Finite

/-Pseudocompact-/
class P22 (X : Type u) [TopologicalSpace X] : Prop where
  p22 : ∀ (f : X → ℝ), Continuous f → Bornology.IsBounded (range f)

/-Weakly locally compact-/
class P23 (X : Type u) [TopologicalSpace X] : Prop where
  p23 : ∀ (x : X), ∃ C ∈ 𝓝 x, IsCompact C

/-Locally relatively compact-/
class P24 (X : Type u) [TopologicalSpace X] : Prop where
  p24 : ∀ x : X, ∃ B : Set (Set X), generate s = 𝓝 x ∧ ∀ s ∈ B, IsCompact (closure s)

/-Exhaustlible by compacts-/
class P25 (X : Type u) [TopologicalSpace X] : Prop extends P17 X, P23 X

/-Separable-/
class P26 (X : Type u) [TopologicalSpace X] : Prop where
  p26 : SeparableSpace X

/-Second countable-/
class P27 (X : Type u) [TopologicalSpace X] : Prop where
  p27 : SecondCountableTopology X

/-First countable-/
class P28 (X : Type u) [TopologicalSpace X] : Prop where
  p28 : FirstCountableTopology X

/-Countable chain condition-/
class P29 (X : Type u) [TopologicalSpace X] : Prop where
  p29 : ∀ (S : Set (Set X)), S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → Countable S

/-Paracompact-/
class P30 (X : Type u) [TopologicalSpace X] : Prop where
  p30 : ParacompactSpace X
