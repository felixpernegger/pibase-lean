import Mathlib.Topology.NoetherianSpace

open TopologicalSpace Set

universe u

namespace PiBase

/- 224. Has cofinite topology -/
class HasCofiniteTopology (X : Type u) [TopologicalSpace X] : Prop where
  open_iff_cofinite (s : Set X) : IsOpen s ↔ sᶜ.Finite

end PiBase
