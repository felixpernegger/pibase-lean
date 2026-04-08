module

public import Mathlib.Topology.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 168. Countable sets are discrete -/
class CountableSetsDiscrete (X : Type u) [TopologicalSpace X] : Prop where
  countable_discrete : ∀ ⦃s : Set X⦄, s.Countable → IsDiscrete s

end PiBase

namespace PiBase.Formal

def P168 : Property where
  toPred := CountableSetsDiscrete
  well_defined φ h := sorry

end PiBase.Formal
