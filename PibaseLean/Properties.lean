import Mathlib
import PibaseLean.AdditionalDefs

universe u v

namespace PiBase

variable {X : Type*} {Y : Type*} [TopologicalSpace X]

open Function Set Filter Topology TopologicalSpace Topology.PiBase.AdditionalDefs

/-- T₀ -/
abbrev P1 (X : Type u) [TopologicalSpace X] : Prop := T0Space X

/-- T₁ -/
abbrev P2 (X : Type u) [TopologicalSpace X] : Prop := T1Space X

/-- T₂ -/
abbrev P3 (X : Type u) [TopologicalSpace X] : Prop := T2Space X

/-- T25 -/
abbrev P4 (X : Type u) [TopologicalSpace X] : Prop := T25Space X

/-- T₃ -/
abbrev P5 (X : Type u) [TopologicalSpace X] : Prop := T3Space X

/-- T35 -/
abbrev P6 (X : Type u) [TopologicalSpace X] : Prop := T35Space X

/-- T₄ -/
abbrev P7 (X : Type u) [TopologicalSpace X] : Prop := T4Space X

/-- T₅ -/
abbrev P8 (X : Type u) [TopologicalSpace X] : Prop := T5Space X

/-- Functionally Hausdorff -/
class P9 (X : Type u) [TopologicalSpace X] : Prop where
  p9 : Pairwise fun x y : X ↦ ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

/-- Semiregular -/
class P10 (X : Type u) [TopologicalSpace X] : Prop where
  p10 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

/-- Regular -/
abbrev P11 (X : Type u) [TopologicalSpace X] : Prop := RegularSpace X

/-- Completely regular -/
abbrev P12 (X : Type u) [TopologicalSpace X] : Prop := CompletelyRegularSpace X

/-- Normal -/
abbrev P13 (X : Type u) [TopologicalSpace X] : Prop := NormalSpace X

/-- Completely normal -/
abbrev P14 (X : Type u) [TopologicalSpace X] : Prop := CompletelyNormalSpace X

/-- Perfectly normal -/
abbrev P15 (X : Type u) [TopologicalSpace X] : Prop := PerfectlyNormalSpace X

/-- Compact -/
abbrev P16 (X : Type u) [TopologicalSpace X] : Prop := CompactSpace X

/-- σ-compact -/
abbrev P17 (X : Type u) [TopologicalSpace X] : Prop := SigmaCompactSpace X

/-- Lindelöf -/
abbrev P18 (X : Type u) [TopologicalSpace X] : Prop := LindelofSpace X

/-- Countably compact -/
class P19 (X : Type u) [TopologicalSpace X] : Prop where
  p19 : ∀ {ι : Type v} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (X = ⋃ i, U i) → ∃ t : Set ι, Countable t ∧ X = ⋃ i ∈ t, U i

/-- Sequentially compact -/
abbrev P20 (X : Type u) [TopologicalSpace X] := SeqCompactSpace X

/-- Weakly countably compact -/
class P21 (X : Type u) [TopologicalSpace X] : Prop where
  p21 : ∀ Y : Set X, ¬ Y.Finite → ∃ x : X, ∀ s ∈ 𝓝 x, (s ∩ Yᶜ).Finite

/-- Pseudocompact -/
class P22 (X : Type u) [TopologicalSpace X] : Prop where
  p22 : ∀ (f : X → ℝ), Continuous f → Bornology.IsBounded (range f)

/-- Weakly locally compact -/
class P23 (X : Type u) [TopologicalSpace X] : Prop where
  p23 : ∀ (x : X), ∃ C ∈ 𝓝 x, IsCompact C

/-- Locally relatively compact -/
class P24 (X : Type u) [TopologicalSpace X] : Prop where
  p24 : ∀ x : X, ∃ B : Set (Set X), generate s = 𝓝 x ∧ ∀ s ∈ B, IsCompact (closure s)

/-- Exhaustlible by compacts -/
class P25 (X : Type u) [TopologicalSpace X] : Prop extends P17 X, P23 X

/-- Separable -/
abbrev P26 (X : Type u) [TopologicalSpace X] := SeparableSpace X

/-- Second countable -/
abbrev P27 (X : Type u) [TopologicalSpace X] := SecondCountableTopology X

/-- First countable -/
abbrev P28 (X : Type u) [TopologicalSpace X] := FirstCountableTopology X

/-- Countable chain condition -/
class P29 (X : Type u) [TopologicalSpace X] : Prop where
  p29 : ∀ (S : Set (Set X)), S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → Countable S

/-- Paracompact -/
abbrev P30 (X : Type u) [TopologicalSpace X] := ParacompactSpace X

/-- Metacompact -/
class P31 (X : Type u) [TopologicalSpace X] : Prop where
  p31 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-- Countably paracompact -/
class P32 (X : Type u) [TopologicalSpace X] : Prop where
  p32 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-- Countably metacompact -/
class P33 (X : Type u) [TopologicalSpace X] : Prop where
  p33 :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

/-- Fully normal -/
class P34 (X : Type u) [TopologicalSpace X] : Prop extends P30 X, P13 X

/-- Fully T₄ -/
class P35 (X : Type u) [TopologicalSpace X] : Prop extends P2 X, P34 X

/-- Connected -/
abbrev P36 (X : Type u) [TopologicalSpace X] := ConnectedSpace X

/-- Path connected -/
abbrev P37 (X : Type u) [TopologicalSpace X] := PathConnectedSpace X

/-- Injectively path connected -/
class P38 (X : Type u) [TopologicalSpace X] : Prop where
  p38 : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ Injective f ∧ f 0 = x ∧ f 1 = y

/-- Hyperconnected -/
class P39 (X : Type u) [TopologicalSpace X] : Prop where
  p39 : ∀ s v : Set X, IsOpen s → IsOpen v → (s ∩ v).Nonempty

/-- Ultraconnected -/
class P40 (X : Type u) [TopologicalSpace X] : Prop where
  p40 : ∀ s v : Set X, IsClosed s → IsClosed v → (s ∩ v).Nonempty

/-- Locally conneced -/
abbrev P41 (X : Type u) [TopologicalSpace X] : Prop := LocallyConnectedSpace X

/-- Locally path conneced -/
class P42 (X : Type u) [TopologicalSpace X] : Prop where
  p42 : ∀ x : X, ∃ s ∈ 𝓝 x, P37 s

/-- Locally injectively path conneced -/
class P43 (X : Type u) [TopologicalSpace X] : Prop where
  p43 : ∀ x : X, ∃ s ∈ 𝓝 x, P38 s

/-- Biconnected -/
class P44 (X : Type u) [TopologicalSpace X] : Prop where
  p44 : P36 X ∧ ∀ s v : Set X, P38 s → encard s ≥ 2 → P38 v → encard v ≥ 2 → (s ∩ v).Nonempty

/-- Has a dispersion point -/
class P45 (X : Type u) [TopologicalSpace X] : Prop where
  p45 : P36 X ∧ ∃ p : X, IsTotallyDisconnected ({p}ᶜ)

/-- Totally path disconnected -/
class P46 (X : Type u) [TopologicalSpace X] : Prop where
  p46 : ∀ f : Icc (0 : ℝ) 1 → X, Continuous f → ∃ x : X, f = const (Icc 0 1) x

/-- Totally disconnected -/
abbrev P47 (X : Type u) [TopologicalSpace X] : Prop := TotallyDisconnectedSpace X

/-- Totally seperated -/
abbrev P48 (X : Type u) [TopologicalSpace X] : Prop := TotallySeparatedSpace X

/-- Extremally disconnected -/
abbrev P49 (X : Type u) [TopologicalSpace X] : Prop := ExtremallyDisconnected X

/-- Zero dimensional -/
class P50 (X : Type u) [TopologicalSpace X] : Prop where
  p50 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

/-- Scattered -/
class P51 (X : Type u) [TopologicalSpace X] : Prop where
  p51 : ∀ Y : Set X, Y.Nonempty → ∃ x : Y, IsOpen {x}

/-- Discrete -/
abbrev P52 (X : Type u) [TopologicalSpace X] : Prop := DiscreteTopology X

/-- Metrizable -/
abbrev P53 (X : Type u) [TopologicalSpace X] : Prop := MetrizableSpace X

/-- Has a σ-locally finite base -/
class P54 (X : Type u) [TopologicalSpace X] : Prop where
  p54 : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

end PiBase
