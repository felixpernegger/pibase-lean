module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 102. Semimetrizable -/
class SemimetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty_semimetric : Nonempty (SemimetricSpace X)

end PiBase
