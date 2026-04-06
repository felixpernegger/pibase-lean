import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Basic

namespace PiBase

/- 222. Has cofinite topology -/
class HasCofiniteTopology (X : Type u) [TopologicalSpace X] : Prop where
  open_iff_cofinite (s : Set X) : IsOpen s ↔ s.Nonempty → sᶜ.Finite

end PiBase
