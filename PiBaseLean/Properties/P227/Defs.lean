module

public import Mathlib.SetTheory.Cardinal.Continuum
public import Mathlib.Topology.Constructions
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open TopologicalSpace Cardinal

namespace PiBase

/- 227. Has a closed discrete subset of cardinality 𝔠 -/
class HasClosedDiscreteSubsetCardContinuum (X : Type*) [TopologicalSpace X] : Prop where
  ex_subset : ∃ s : Set X, IsDiscrete s ∧ IsClosed s ∧ #s = 𝔠

end PiBase
