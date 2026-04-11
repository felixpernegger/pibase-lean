module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 102. Semimetrizable -/
class SemimetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty_semimetric : Nonempty (SemimetricSpace X)

end PiBase

namespace PiBase.Formal

def P102 : Property where
  toPred := SemimetrizableSpace
  well_defined φ h := sorry

end PiBase.Formal
