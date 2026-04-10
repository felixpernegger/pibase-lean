module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 173. Pseudoradial -/
class PseudoradialSpace (X : Type u) [TopologicalSpace X] : Prop where
  radiallyClosed_isClosed : ∀ ⦃s : Set X⦄, IsRadiallyClosed s → IsClosed s

end PiBase

namespace PiBase.Formal

def P173 : Property where
  toPred := PseudoradialSpace
  well_defined φ h := sorry

end PiBase.Formal
