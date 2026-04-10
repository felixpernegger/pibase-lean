module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

namespace PiBase

/- 101. Has closed retracts -/
class HasClosedRetract (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_retract : ∀ A : Set X, IsRetract A → IsClosed A

end PiBase

namespace PiBase.Formal

def P101 : Property where
  toPred := HasClosedRetract
  well_defined {X Y} _ _ φ h := sorry

end PiBase.Formal
