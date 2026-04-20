module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P134.Defs
public import PiBaseLean.Properties.P12.Lemmas
public import PiBaseLean.Theorems.T27.BackgroundLemmas

@[expose] public section

universe u

open Set Function Topology Filter

open scoped OnePoint

namespace PiBase

/-- Theorem T27: P23 (WeaklyLocallyCompactSpace) + P134 (R1Space) => P12 (CompletelyRegularSpace) -/
instance instCompletelyRegularSpaceOfWeaklyLocallyCompactSpaceOfR1Space (X : Type u)
    [TopologicalSpace X] [WeaklyLocallyCompactSpace X] [R1Space X] : CompletelyRegularSpace X :=
  IsInducing.completelyRegularSpace <|
    Homeomorph.isInducing (OnePoint.isOpenEmbedding_coe (X := X)).toIsEmbedding.toHomeomorph

end PiBase

namespace PiBase.Formal

theorem T27 : P23 ⊓ P134 ≤ P12 :=
  fun X _ ⟨h1, h2⟩ ↦ @instCompletelyRegularSpaceOfWeaklyLocallyCompactSpaceOfR1Space X _ h1 h2

end PiBase.Formal
