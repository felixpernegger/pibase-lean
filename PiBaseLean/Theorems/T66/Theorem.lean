module

public import PiBaseLean.Properties.Bundled.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.P133.Bundled
public import PiBaseLean.Properties.P154.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T66: P133 (Lots) => P154 (GoSpace) -/
instance instGoSpaceOfLots (X : Type u)
    [τ : TopologicalSpace X] [h : Lots X] :
    GoSpace X where
  subset_lots := ⟨X, id, τ, h, IsEmbedding.id⟩

end PiBase

namespace PiBase.Formal

theorem T66 : P133 ≤ P154 := fun X _ ↦ @instGoSpaceOfLots X _

end PiBase.Formal
