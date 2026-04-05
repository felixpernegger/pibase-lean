import Mathlib.Topology.NoetherianSpace

open TopologicalSpace

namespace PiBase

/- 226. Artinian -/
abbrev ArtinianSpace (X : Type*) [TopologicalSpace X] := WellFoundedGT (Closeds X)

end PiBase
