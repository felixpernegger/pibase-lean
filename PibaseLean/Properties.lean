import Mathlib
import PibaseLean.AdditionalDefs

universe u v

namespace PiBase

variable {X : Type*} {Y : Type*} [TopologicalSpace X]

open Function Set Filter Topology TopologicalSpace Topology.PiBase.AdditionalDefs

/-1. T₀ -/
#check T0Space X

/-2. T₁ -/
#check T1Space

/-3. T₂ -/
#check T2Space

/-4. T₃ -/
#check T25Space

/-5. T₃ -/
#check T3Space

/-6. T35 -/
#check T35Space

/-7. T₄ -/
#check T4Space

/-8. T₅ -/
#check T5Space

/-9. Functionally Hausdorff -/
class CompletelyT2Space (X : Type u) [TopologicalSpace X] : Prop where
  p9 : Pairwise fun x y : X ↦ ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

/-10. Semiregular -/
class SemiregularSpace (X : Type u) [TopologicalSpace X] : Prop where
  p10 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

/-11. Regular -/
#check RegularSpace

/-12. Completely regular -/
#check CompletelyRegularSpace

/-13. Normal -/
#check NormalSpace

/-14. Completely normal -/
#check CompletelyNormalSpace

/-15. Perfectly normal -/
#check PerfectlyNormalSpace

/-16. Compact -/
#check CompactSpace

/-17. σ-compact -/
#check SigmaCompactSpace

/-18. Lindelöf -/
#check LindelofSpace

/-19. Countably compact -/
class CountablyCompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  countablyCompact : ∀ {ι : Type v} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (X = ⋃ i, U i) → ∃ t : Set ι, Countable t ∧ Set.univ ⊆ ⋃ i ∈ t, U i

/-20. Sequentially compact -/
#check SeqCompactSpace

/-21. Weakly countably compact -/
class WeaklyCountablyCompact (X : Type u) [TopologicalSpace X] : Prop where
  p21 : ∀ Y : Set X, ¬ Y.Finite → ∃ x : X, ∀ s ∈ 𝓝 x, (s ∩ Yᶜ).Finite

/-22. Pseudocompact -/
class Pseudocompact (X : Type u) [TopologicalSpace X] : Prop where
  p22 : ∀ (f : X → ℝ), Continuous f → Bornology.IsBounded (range f)

/-23. Weakly locally compact -/
class WeaklyLocallyCompact (X : Type u) [TopologicalSpace X] : Prop where
  p23 : ∀ (x : X), ∃ C ∈ 𝓝 x, IsCompact C

/-24. Locally relatively compact -/
class LocallyRelativelyCompact (X : Type u) [TopologicalSpace X] : Prop where
  p24 : ∀ x : X, ∃ B : Set (Set X), generate B = 𝓝 x ∧ ∀ s ∈ B, IsCompact (closure s)

/-25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type u) [TopologicalSpace X] : Prop
  extends SigmaCompactSpace X, WeaklyLocallyCompact X

/-26. Separable -/
#check SeparableSpace

/-27. Second countable -/
#check SecondCountableTopology

/-28. First countable -/
#check FirstCountableTopology

/-29. Countable chain condition -/
class CountableChainCondition (X : Type u) [TopologicalSpace X] : Prop where
  p29 : ∀ (S : Set (Set X)), S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → Countable S

/-30. Paracompact -/
#check ParacompactSpace

/-31. Metacompact -/
class MetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p31 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-32. Countably paracompact -/
class CountablyParacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p32 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-33. Countably metacompact -/
class CountablyMetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  p33 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-34. Fully normal -/
class FullyNormalSpace (X : Type u) [TopologicalSpace X] : Prop
  extends ParacompactSpace X, NormalSpace X

/-35. Fully T₄ -/
class FullyT4Space (X : Type u) [TopologicalSpace X] : Prop extends T1Space X, FullyNormalSpace X

/-36. Connected -/ --Attention! Mathlib requires the space to be nonempty, while π-Base does not.
#check PreconnectedSpace

/-37. Path connected -/
class PrePathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  joined : ∀ x y : X, Joined x y

/-38. Injectively path connected -/
class InjPrePathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p38 : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ Injective f ∧ f 0 = x ∧ f 1 = y

/-39. Hyperconnected -/
class HyperconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p39 : ∀ s v : Set X, IsOpen s → IsOpen v → (s ∩ v).Nonempty

/-40. Ultraconnected -/
class UltraconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p40 : ∀ s v : Set X, IsClosed s → IsClosed v → (s ∩ v).Nonempty

/-41. Locally conneced -/ --Again difference between mathlib!
class LocallyPreconnectedSpace (α : Type*) [TopologicalSpace α] : Prop where
  open_connected_basis : ∀ x, (𝓝 x).HasBasis (fun s : Set α => IsOpen s ∧ x ∈ s ∧ IsConnected s) id

/-Locally path-connected-/
class LocallyPrePathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p42 : ∀ x : X, ∃ s ∈ 𝓝 x, PrePathConnectedSpace s

/-43. Locally injectively path conneced -/
class LocallyInjPrePathConnected (X : Type u) [TopologicalSpace X] : Prop where
  p43 : ∀ x : X, ∃ s ∈ 𝓝 x, InjPrePathConnectedSpace s

/-44. Biconnected -/
class BiconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  preconnted : PreconnectedSpace X
  no_partition : ∀ s v : Set X,
    ConnectedSpace s → encard s ≥ 2 → ConnectedSpace v → encard v ≥ 2 → (s ∩ v).Nonempty

/-45. Has a dispersion point -/
class HasDispersionPoint (X : Type u) [TopologicalSpace X] : Prop where
  preconnected : PreconnectedSpace X
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected ({p}ᶜ)

/-46. Totally path disconnected -/
class TotallyPathDisconnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  p46 : ∀ f : Icc (0 : ℝ) 1 → X, Continuous f → ∃ x : X, f = const (Icc 0 1) x

/-47. Totally disconnected -/
#check TotallyDisconnectedSpace

/-48. Totally seperated -/
#check TotallySeparatedSpace

/-49. Extremally disconnected -/
#check ExtremallyDisconnected

/-50. Zero dimensional -/
class ZeroDimensionalSpace (X : Type u) [TopologicalSpace X] : Prop where
  p50 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

/-51. Scattered -/
class ScatteredSpace (X : Type u) [TopologicalSpace X] : Prop where
  p51 : ∀ Y : Set X, Y.Nonempty → ∃ x : Y, IsOpen {x}

/-52. Discrete -/
#check DiscreteTopology

/-53. Metrizable -/
#check MetrizableSpace

/-54. Has a σ-locally finite base -/
class HasSigmaLocallyFiniteBase (X : Type u) [TopologicalSpace X] : Prop where
  p54 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

end PiBase
