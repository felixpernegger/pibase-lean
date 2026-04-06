import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Basic

universe u

namespace PiBase

/- 222. Has cofinite topology -/
class HasCofiniteTopology (X : Type u) [TopologicalSpace X] : Prop where
  open_iff_cofinite (s : Set X) : IsOpen s ↔ sᶜ.Finite

end PiBase
