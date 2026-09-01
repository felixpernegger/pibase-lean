module

public import Mathlib.Topology.Homeomorph.Defs
public import Mathlib.Topology.Order

@[expose] public section

namespace PiBase.SpaceConstructions

/-- The finite discrete space on `n` points. -/
def FiniteDiscrete (n : Nat) := Fin n

instance (n : Nat) : TopologicalSpace (FiniteDiscrete n) := ⊥

instance (n : Nat) : DiscreteTopology (FiniteDiscrete n) := ⟨rfl⟩

/-- The finite indiscrete space on `n` points. -/
def FiniteIndiscrete (n : Nat) := Fin n

instance (n : Nat) : TopologicalSpace (FiniteIndiscrete n) := ⊤

instance (n : Nat) : IndiscreteTopology (FiniteIndiscrete n) := ⟨rfl⟩

end PiBase.SpaceConstructions
