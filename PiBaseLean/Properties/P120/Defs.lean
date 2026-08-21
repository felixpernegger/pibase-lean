module

public import PiBaseLean.Properties.P133.Defs

@[expose] public section

open Topology

universe u

namespace PiBase

/- 120. Locally orderable -/
class LocallyOrderableSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_nbhd_lots (x : X) : ∃ s ∈ 𝓝 x, Lots s

end PiBase
