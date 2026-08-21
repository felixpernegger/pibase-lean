module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P191.Bundled
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P28.Bundled

import Mathlib.Topology.Separation.GDelta

@[expose] public section

universe u

namespace PiBase

/-- Theorem T501: P28 (FirstCountableTopology) + P2 (T1Space) => P191 (HasGδSingletons) -/
instance instHasGδSingletonsOfFirstCountableTopologyOfT1Space {X : Type u}
    [TopologicalSpace X] [FirstCountableTopology X] [T1Space X] : HasGδSingletons X where
  isGδ_singleton x := IsGδ.singleton x

end PiBase

namespace PiBase.Formal

theorem T501 : P28 ⊓ P2 ≤ P191 :=
  fun X _ ⟨h1, h2⟩ ↦ @instHasGδSingletonsOfFirstCountableTopologyOfT1Space X _ h1 h2

end PiBase.Formal
