module

public import PiBaseLean.Properties.P133.Defs

@[expose] public section

open Topology

universe u

namespace PiBase

/- 154. GO-space -/
class GoSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_lots : ∃ (Z : Type u) (f : X → Z) (_ : TopologicalSpace Z),
    Lots Z ∧ IsEmbedding f

end PiBase
