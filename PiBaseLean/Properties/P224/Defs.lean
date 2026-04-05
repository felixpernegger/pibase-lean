import Mathlib.Topology.NoetherianSpace

open TopologicalSpace Set

namespace PiBase

/- 224. Has cofinite topology -/
class HasCofiniteTopology (X : Type*) [TopologicalSpace X] : Prop where
  open_iff_cofinite (s : Set X) : IsOpen s ↔ s.Nonempty → sᶜ.Finite

end PiBase
