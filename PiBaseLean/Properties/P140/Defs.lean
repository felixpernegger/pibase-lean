module

public import Mathlib.Topology.Compactness.Compact
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

open scoped Set.Notation

universe u

namespace PiBase

/- 140. k₁-space -/
class K1Space (X : Type u) [TopologicalSpace X] : Prop where
  isOpen_of_compact (s : Set X) : (∀ K : Set X, IsCompact K → IsOpen (K ↓∩ s)) → IsOpen s

end PiBase

namespace PiBase.Formal

def P140 : Property where
  toPred := K1Space
  well_defined φ h := sorry

end PiBase.Formal
