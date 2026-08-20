module

public import PiBaseLean.AdditionalDefs.Games
public import Mathlib.Topology.UniformSpace.Basic
public import Mathlib.Topology.UniformSpace.UniformEmbedding

@[expose] public section

universe u

namespace PiBase

/- 76. Proximal -/
class ProximalSpace (X : Type u) [τ : TopologicalSpace X] : Prop where
  proximal (h : Inhabited X) :
    ∃ t : UniformSpace X, t.toTopologicalSpace = τ ∧ HasWinningStrategyA (@proximalGame X t h)

end PiBase
