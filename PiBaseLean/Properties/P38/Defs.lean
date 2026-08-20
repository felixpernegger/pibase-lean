module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

open Function Topology Set

namespace PiBase

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : IsInjPathConnected (Set.univ (α := X))

end PiBase
