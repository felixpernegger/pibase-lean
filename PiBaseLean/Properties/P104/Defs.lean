module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 104. Symmetrizable -/
class SymmetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty_symmetric : Nonempty (SymmetricSpace X)

end PiBase

namespace PiBase.Formal

def P104 : Property where
  toPred := SymmetrizableSpace
  well_defined φ h := sorry

end PiBase.Formal
