module

public import Mathlib.Topology.Bases
public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 10. Semiregular -/
class SemiregularSpace (X : Type*) [TopologicalSpace X] : Prop where
  semiregular : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsRegularOpen s

end PiBase
