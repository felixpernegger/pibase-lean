module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 104. Symmetrizable -/
class SymmetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty_symmetric : Nonempty (SymmetricSpace X)

end PiBase
