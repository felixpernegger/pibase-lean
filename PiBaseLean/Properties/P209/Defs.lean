import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.Topology.Defs.Basic

open TopologicalSpace Set Cardinal

universe u

namespace PiBase

/- 209. Density ≤ 𝔠 -/
class DensityLeContinuum (X : Type u) [TopologicalSpace X] : Prop where
  ex_dense : ∃ s : Set X, Dense s ∧ #s ≤ 𝔠

end PiBase
