import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.Topology.Defs.Basic

open TopologicalSpace Set Cardinal

namespace PiBase

/- 209. Density ≤ 𝔠 -/
class DensityLeContinuum (X : Type*) [TopologicalSpace X] : Prop where
  ex_dense : ∃ s : Set X, Dense s ∧ #s ≤ 𝔠

end PiBase
