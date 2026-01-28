import Mathlib
import PibaseLean.AdditionalDefs

universe u v

namespace PiBase

variable (X : Type*) {Y : Type*} [TopologicalSpace X]

open Function Set Filter Topology TopologicalSpace Set.Notation Topology.PiBase.AdditionalDefs

/- 1. T₀ -/
#check T0Space X

/- 2. T₁ -/
#check T1Space

/- 3. T₂ -/
#check T2Space

/- 4. T₃ -/
#check T25Space

/- 5. T₃ -/
#check T3Space

/- 6. T35 -/
#check T35Space

/- 7. T₄ -/
#check T4Space

/- 8. T₅ -/
#check T5Space

/- 9. Functionally Hausdorff -/
class CompletelyT2Space (X : Type u) [TopologicalSpace X] : Prop where
  p9 : Pairwise fun x y : X ↦ ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

/- 10. Semiregular -/
class SemiregularSpace (X : Type u) [TopologicalSpace X] : Prop where
  p10 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

/- 11. Regular -/
#check RegularSpace

/- 12. Completely regular -/
#check CompletelyRegularSpace

/- 13. Normal -/
#check NormalSpace

/- 14. Completely normal -/
#check CompletelyNormalSpace

/- 15. Perfectly normal -/
#check PerfectlyNormalSpace

/- 16. Compact -/
#check CompactSpace

/- 17. σ-compact -/
#check SigmaCompactSpace

/- 18. Lindelöf -/
#check LindelofSpace

/- 19. Countably compact -/
@[mk_iff]
class CountablyCompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  countablyCompact : ∀ {ι : Type u} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (X = ⋃ i, U i) → ∃ t : Set ι, Countable t ∧ Set.univ ⊆ ⋃ i ∈ t, U i

/- 20. Sequentially compact -/
#check SeqCompactSpace

/- 21. Weakly countably compact -/
@[mk_iff]
class WeaklyCountablyCompact (X : Type u) [TopologicalSpace X] : Prop where
  p21 : ∀ Y : Set X, ¬ Y.Finite → ∃ x : X, ∀ s ∈ 𝓝 x, (s ∩ Yᶜ).Finite

/- 22. Pseudocompact -/
class Pseudocompact (X : Type u) [TopologicalSpace X] : Prop where
  p22 : ∀ (f : X → ℝ), Continuous f → Bornology.IsBounded (range f)

/- 23. Weakly locally compact -/
class WeaklyLocallyCompact (X : Type u) [TopologicalSpace X] : Prop where
  p23 : ∀ (x : X), ∃ C ∈ 𝓝 x, IsCompact C

/- 24. Locally relatively compact -/
class LocallyRelativelyCompact (X : Type u) [TopologicalSpace X] : Prop where
  p24 : ∀ x : X, ∃ B : Set (Set X), generate B = 𝓝 x ∧ ∀ s ∈ B, IsCompact (closure s)

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type u) [TopologicalSpace X] : Prop
  extends SigmaCompactSpace X, WeaklyLocallyCompact X

/- 26. Separable -/
#check SeparableSpace

/- 27. Second countable -/
#check SecondCountableTopology

/- 28. First countable -/
#check FirstCountableTopology

/- 29. Countable chain condition -/
class CountableChainCondition (X : Type u) [TopologicalSpace X] : Prop where
  p29 : ∀ (S : Set (Set X)), S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → Countable S

/- 30. Paracompact -/
#check ParacompactSpace

/- 31. Metacompact -/
class MetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p31 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/- 32. Countably paracompact -/
class CountablyParacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p32 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/- 33. Countably metacompact -/
class CountablyMetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p33 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/- 34. Fully normal -/
class FullyNormalSpace (X : Type u) [TopologicalSpace X] : Prop
  extends ParacompactSpace X, NormalSpace X

/- 35. Fully T₄ -/
class FullyT4Space (X : Type u) [TopologicalSpace X] : Prop extends T1Space X, FullyNormalSpace X

/- 36. Connected -/ --Attention! Mathlib requires the space to be nonempty, while π-Base does not.
#check ConnectedSpace

/- 37. Path connected -/ --This differs from mathlib!
#check PathConnectedSpace

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ Injective f ∧ f 0 = x ∧ f 1 = y

/- 39. Hyperconnected -/
class HyperconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p39 : ∀ s v : Set X, IsOpen s → IsOpen v → (s ∩ v).Nonempty

/- 40. Ultraconnected -/
class UltraconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p40 : ∀ s v : Set X, IsClosed s → IsClosed v → (s ∩ v).Nonempty

/- 41. Locally conneced -/ --Again difference between mathlib!
#check LocallyConnectedSpace

/- Locally path-connected-/
class LocallyPathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p42 : ∀ x : X, ∃ s ∈ 𝓝 x, PathConnectedSpace s

/- 43. Locally injectively path conneced -/
class LocallyInjPathConnected (X : Type u) [TopologicalSpace X] : Prop where
  p43 : ∀ x : X, ∃ s ∈ 𝓝 x, InjPathConnectedSpace s

/- 44. Biconnected -/
class BiconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  preconnted : PreconnectedSpace X
  no_partition : ∀ s v : Set X,
    ConnectedSpace s → encard s ≥ 2 → ConnectedSpace v → encard v ≥ 2 → (s ∩ v).Nonempty

/- 45. Has a dispersion point -/
class HasDispersionPoint (X : Type u) [TopologicalSpace X] : Prop where
  preconnected : PreconnectedSpace X
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected ({p}ᶜ)

/- 46. Totally path disconnected -/
class TotallyPathDisconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p46 : ∀ f : Icc (0 : ℝ) 1 → X, Continuous f → ∃ x : X, f = const (Icc 0 1) x

/- 47. Totally disconnected -/
#check TotallyDisconnectedSpace

/- 48. Totally seperated -/
#check TotallySeparatedSpace

/- 49. Extremally disconnected -/
#check ExtremallyDisconnected

/- 50. Zero dimensional -/
class ZeroDimensionalSpace (X : Type u) [TopologicalSpace X] : Prop where
  p50 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

/- 51. Scattered -/
class ScatteredSpace (X : Type u) [TopologicalSpace X] : Prop where
  p51 : ∀ Y : Set X, Y.Nonempty → ∃ x : Y, IsOpen {x}

/- 52. Discrete -/
#check DiscreteTopology

/- 53. Metrizable -/
#check MetrizableSpace

/- 54. Has a σ-locally finite base -/
class HasSigmaLocallyFiniteBase (X : Type u) [TopologicalSpace X] : Prop where
  p54 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

/- 55. Completely metrizable -/
#check IsCompletelyMetrizableSpace

/- 56. Meager -/
class MeagreSpace (X : Type u) [TopologicalSpace X] : Prop where
  p56 : IsMeagre (univ (α := X))

/- 57. Countably -/
#check Countable


--maybe the card results aren't 100% correct.
section card

open Cardinal

/- 58. Cardinality < 𝔠-/
class CardLtContinuum (X : Type u) where
  card_lt : #X < 𝔠

/- 59. Cardinality < 2 ^ 𝔠  -/
class CardLessPowerContinuum (X : Type u) where
  card_lt : #X < 2 ^ 𝔠

end card

/- 60. Strongly connected -/
class StronglyConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  isStronglyConnected : ∀ f : X → ℝ, Continuous f → ∃ r : ℝ, f = Function.const X r

/- 61. Cozero complemented -/
class CozeroComplementedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p61 : ∀ s : Set X, IsCozero s → ∃ t : Set X, IsCozero t ∧ Dense (s ∪ t)

/- 62. Weakly Lindelöf -/
class WeaklyLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  p62 : ∀ {ι : Type*} (U : ι → Set X),
    (∀ i, IsOpen (U i)) →  (X = ⋃ i, U i) → ∃ t : Set ι, t.Countable ∧ Dense (⋃ i ∈ t, U i)

/- 63. Cech complete-/
--TDODO

/- 64. Baire -/
#check BaireSpace

section card

open Cardinal

/- 65. Cardinality = 𝔠  -/
class CardEqContinuum (X : Type u) where
  card_eq : #X  = 𝔠

end card

/- 66. Menger -/
class MengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  p66 : ∀ {ι : Type u} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ s : ℕ → (Finset ι), univ = ⋃ (n : ℕ), ⋃ i ∈ s n, U n i

/- 67. T6 -/
#check T6Space

/- 68. Rothberger -/
class RothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  p66 : ∀ {ι : Type u} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ j : ℕ → ι, univ = ⋃ (n : ℕ), U n (j n)

/- 69. Strategic Menger -/
--TODO: Topological game

/- 70. Markov Menger -/
--TODO: Topological game

/- 71. σ-relatviely compact -/
class SigmaRelativelyCompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p71 : ∃ R : ℕ → Set X, X = ⋃ n : ℕ, R n ∧ ∀ n : ℕ, IsRelativelyCompact (R n)

/- 72. 2 Markov Menger -/
--TODO: Topological game

/- 73. Sober -/
class SoberSpace (X : Type u) [TopologicalSpace X] : Prop where
  p73 : ∀ {S : Set X}, IsIrreducible S → IsClosed S → ∃! x, IsGenericPoint x S

/- 182. Has a countable network -/
class HasCountableNetwork (X : Type u) [TopologicalSpace X] : Prop where
  p182 : ∃ (N : ℕ → Set X),
    ∀ (x : X) (U : Set X) (_ : U ∈ 𝓝 x), ∃ i : ℕ, x ∈ N i ∧ N i ⊆ U

/- 74. Cosmic -/
class CosmicSpace (X : Type u) [TopologicalSpace X] : Prop extends
  T3Space X, HasCountableNetwork X

/- 75. Spectral Space -/
#check SpectralSpace

/- 76. Proximal -/
--TODO: Topological game

/- 77. Corson compact -/
--TODO

/- 78. Finite -/
#check Finite

/- 79. Seqeuential -/
#check SequentialSpace

/- 80. Frechet Urysohn -/
#check FrechetUrysohnSpace

/- 81. Countably tight space -/
class CountablyTightSpace (X : Type u) [TopologicalSpace X] : Prop where
  p81 : ∀ (x : X) (A : Set X), x ∈ closure A → ∃ D : Set X, D.Countable ∧ D ⊆ A ∧ x ∈ closure D

/- 82. Locally metrizable -/
class LocallyMetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  p82 : ∀ (x : X), ∃ C : Set X, C ∈ 𝓝 x ∧ MetrizableSpace C

/- 83. Meta Lindelöf -/
class MetaLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  p83 :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointCountable t ∧ ∀ b, ∃ a, t b ⊆ s a

/- 84. Locally metrizable -/
class LocallyT2Space (X : Type u) [TopologicalSpace X] : Prop where
  p84 : ∀ (x : X), ∃ C : Set X, C ∈ 𝓝 x ∧ T2Space C

/- 85. Basically disconnected -/
class BasicallyDisconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p85 : ∀ (U : Set X), IsCozero U → IsOpen (closure U)

/- 86. Homogenous -/
class HomogenousSpace (X : Type u) [TopologicalSpace X] : Prop where
  p86 : ∀ (x y : X), ∃ f : X ≃ₜ X,  f x = y

/- 87. Has Group Topology -/
class HasGroupTopology (X : Type u) [TopologicalSpace X] : Prop where
  p87 : ∃ (_ : Group X), IsTopologicalGroup X

/- 88. Collectionwise normal -/
class CollectionwiseNormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  p88 : ∀ {ι : Type u} (F : ι → Set X), IsDiscreteFamily F → (∀ i : ι, IsClosed (F i)) →
    ∃ U : ι → Set X, (univ.PairwiseDisjoint U) ∧ (∀ i : ι, IsOpen (U i)) ∧ (∀ i : ι, U i ⊆ F i)

/- 89. Fixed point property -/
class FixedPointSpace (X : Type u) [TopologicalSpace X] : Prop where
  p89 : ∀ (f : X → X), Continuous f → ∃ x : X, f x = x

/- 90. Alexandrov -/
#check AlexandrovDiscrete

/- 91. Eberlein compact -/
--TODO

/- 92. k ω 3 space -/
class kωSpace (X : Type u) [TopologicalSpace X] : Prop where
  p92 : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧ (∀ n : ℕ, T2Space (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

/- 93. Locally countable (slightly different wording than pibase) -/
class LocallyCountableSpace (X : Type u) [TopologicalSpace X] : Prop where
  p93 : ∀ x : X, ∃ s ∈ 𝓝 x, s.Countable

/- 94. Locally countable (slightly different wording than pibase) -/
class LocallyFiniteSpace (X : Type u) [TopologicalSpace X] : Prop where
  p93 : ∀ x : X, ∃ s ∈ 𝓝 x, s.Finite

/- 95. Arc connected -/
class ArcConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, IsEmbedding f ∧ f 0 = x ∧ f 1 = y

/- 96. Locally Arc connected -/
class LocallyArcConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  joined : ∀ x : X, ∃ B : Set (Set X), generate B = 𝓝 x ∧ ∀ s ∈ B, ArcConnectedSpace s

/- 97. Embeddable in ℝ -/
class EmbeddableInR (X : Type u) [TopologicalSpace X] : Prop where
  p97 : ∃ f : X → ℝ, IsEmbedding f

/- 98. k ω 1 space -/
class kωSpace' (X : Type u) [TopologicalSpace X] : Prop where
  p98 : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

/- 99. US -/
class UsSpace (X : Type u) [TopologicalSpace X] : Prop where
  p99 : ∀ (f : Y → X) (l : Filter Y) (a b : X), (_ : NeBot l)
    → (Tendsto f l (𝓝 a)) → (Tendsto f l (𝓝 b)) → a = b

/- 100. KC Space -/
class KcSpace (X : Type u) [TopologicalSpace X] : Prop where
  p100 : ∀ s : Set X, IsCompact s → IsClosed s

/- 101. Has closed retracts -/
class HasClosedRetract (X : Type u) [TopologicalSpace X] : Prop where
  p101 : ∀ A : Set X, IsRetractSet A → IsClosed A

/- 102. Semimetrizable -/
-- TODO

/- 103. Strongly KC -/
-- TODO

/- 104. Symmetrizable -/
-- TODO

/- 105. Para-Lindelöf -/
class ParaLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  p31 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyCountable t ∧ ∀ b, ∃ a, t b ⊆ s a

section card

open Cardinal

class TorontoSpace (X : Type u) [TopologicalSpace X] where
  toronto : ∀ Y : Set X, #Y = #X → Y ≃ₜ X

instance Finite.torontoSpace (X : Type u) [TopologicalSpace X] [Finite X] : TorontoSpace X where
  toronto := by
    intro Y hY
    have eq : Y = Set.univ := by
      refine (eq_univ_iff_ncard Y).mpr ?_
      have : Y.ncard = (#↑Y).toNat := by
        exact rfl
      rw [this, hY]
      exact rfl
    rw [eq]
    exact Homeomorph.Set.univ X

end card

end PiBase
