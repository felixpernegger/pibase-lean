module

public import PiBaseLean.Properties.P133.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 120. Locally orderable -/
class LocallyOrderableSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_nbhd_lots (x : X) : ∃ s ∈ 𝓝 x, LOTS s

end PiBase

namespace PiBase.Formal

def P120 : Property where
  toPred := LocallyOrderableSpace
  well_defined φ h := sorry

end PiBase.Formal
