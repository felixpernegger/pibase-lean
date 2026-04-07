module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 222. Has cofinite topology -/
class HasCofiniteTopology (X : Type u) [TopologicalSpace X] : Prop where
  open_iff_cofinite (s : Set X) : IsOpen s ↔ s.Nonempty → sᶜ.Finite

end PiBase

namespace PiBase.Formal

def P222 : Property where
  toPred := HasCofiniteTopology
  well_defined φ h := sorry

end PiBase.Formal
