import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

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
