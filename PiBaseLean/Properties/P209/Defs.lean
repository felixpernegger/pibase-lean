module

public import Mathlib.SetTheory.Cardinal.Continuum
public import Mathlib.Topology.Defs.Basic

@[expose] public section

open Cardinal

namespace PiBase

/- 209. Density ≤ 𝔠 -/
class DensityLeContinuum (X : Type*) [TopologicalSpace X] : Prop where
  ex_dense : ∃ s : Set X, Dense s ∧ #s ≤ 𝔠

end PiBase
