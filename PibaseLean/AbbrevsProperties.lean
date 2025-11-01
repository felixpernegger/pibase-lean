import Mathlib
import PibaseLean.Properties

namespace PiBase



open Topology TopologicalSpace

/-- T₀ -/
abbrev P1 := T0Space

/-- T₁ -/
abbrev P2 := T1Space

/-- T₂ -/
abbrev P3 := T2Space

/-- T25 -/
abbrev P4 := T25Space

/-- T₃ -/
abbrev P5 := T3Space

/-- T35 -/
abbrev P6 := T35Space

/-- T₄ -/
abbrev P7 := T4Space

/-- T₅ -/
abbrev P8 := T5Space

/-- Functionally Hausdorff -/
abbrev P9 := CompletelyT2Space

/-- Semiregular -/
abbrev P10 := SemiregularSpace

/-- Regular -/
abbrev P11 := RegularSpace

/-- Completely regular -/
abbrev P12 := CompletelyRegularSpace

/-- Normal -/
abbrev P13 := NormalSpace

/-- Completely normal -/
abbrev P14 := CompletelyNormalSpace

/-- Perfectly normal -/
abbrev P15 := PerfectlyNormalSpace

/-- Compact -/
abbrev P16 := CompactSpace

/-- σ-compact -/
abbrev P17 := SigmaCompactSpace

/-- Lindelöf -/
abbrev P18 := LindelofSpace

/-
/-- Countably compact -/
abbrev P19 := CountablyCompactSpace
-/

/-- Sequentially compact -/
abbrev P20 := SeqCompactSpace

/-- Weakly countably compact -/
abbrev P21 := WeaklyCountablyCompact

/-- Pseudocompact -/
abbrev P22 := Pseudocompact

/-- Weakly locally compact -/
abbrev P23 := WeaklyLocallyCompact

/-- Locally relatively compact -/
abbrev P24 := LocallyRelativelyCompact

/-- Exhaustlible by compacts -/
abbrev P25 := ExhaustibleByCompacts

/-- Separable -/
abbrev P26 := SeparableSpace

/-- Second countable -/
abbrev P27 := SecondCountableTopology

/-- First countable -/
abbrev P28 := FirstCountableTopology

/-- Countable chain condition -/
abbrev P29 := CountableChainCondition

/-- Paracompact -/
abbrev P30 := ParacompactSpace

/-
/-- MetacompactSpace -/
abbrev P31 := MetacompactSpace

/-- Countably metacompact -/
abbrev P32 := CountablyParacompactSpace

/-- Fully normal -/
abbrev P33 := CountablyMetacompactSpace
-/

/-- Fully normal -/
abbrev P34 := FullyNormalSpace

/-- Fully T₄ -/
abbrev P35 := FullyT4Space

/-- (Pre-)Connected -/ --Difference between mathlib and π-base
abbrev P36 := PreconnectedSpace

/-- Path connected -/
abbrev P37 := PrePathConnectedSpace

/-- Injectively path connected -/
abbrev P38 := InjPrePathConnectedSpace

/-- Hyperconnected -/
abbrev P39 := HyperconnectedSpace

/-- Ultraconnected -/
abbrev P40 := UltraconnectedSpace

/-- Locally conneced -/ --!!!
abbrev P41 := LocallyPreconnectedSpace

/-- Locally path conneced -/
abbrev P42 := LocallyPrePathConnectedSpace

/-- Locally injectively path conneced -/
abbrev P43 := LocallyInjPrePathConnected

/-- Biconnected -/
abbrev P44 := BiconnectedSpace

/-- Has a dispersion point -/
abbrev P45 := HasDispersionPoint

/-- Totally path disconnected -/
abbrev P46 := TotallyPathDisconnectedSpace

/-- Totally disconnected -/
abbrev P47 := TotallyDisconnectedSpace

/-- Totally seperated -/
abbrev P48 := TotallySeparatedSpace

/-- Extremally disconnected -/
abbrev P49 := ExtremallyDisconnected

/-- Zero dimensional -/
abbrev P50 := ZeroDimensionalSpace

/-- Scattered -/
abbrev P51 := ScatteredSpace

/-- Discrete -/
abbrev P52 := DiscreteTopology

/-- Metrizable -/
abbrev P53 := MetrizableSpace

/-- Has a σ-locally finite base -/
abbrev P54 := HasSigmaLocallyFiniteBase

end PiBase
