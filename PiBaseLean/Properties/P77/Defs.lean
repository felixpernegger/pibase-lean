module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 77. Corson compact -/
class CorsonCompactSpace (X : Type u) [TopologicalSpace X] : Prop extends CompactSpace X where
  isHomoeo_subset : ∃ α : Type u, ∃ s : Set (SigmaProduct (fun (_ : α) ↦ (0 : ℝ))),
    IsHomeo X s

end PiBase

namespace PiBase.Formal

def P77 : Property where
  toPred := CorsonCompactSpace
  well_defined φ h := sorry

end PiBase.Formal
