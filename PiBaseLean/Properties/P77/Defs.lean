module

public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 77. Corson compact -/
class CorsonCompactSpace (X : Type u) [TopologicalSpace X] : Prop extends CompactSpace X where
  isHomoeo_subset : ∃ α : Type u, ∃ f : X → (SigmaProduct (fun (_ : α) ↦ (0 : ℝ))),
    Topology.IsEmbedding f

end PiBase
