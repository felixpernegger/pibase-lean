import Mathlib.Topology.NoetherianSpace

open TopologicalSpace

universe u

namespace PiBase

/- 226. Artinian -/
abbrev ArtinianSpace (X : Type u) [TopologicalSpace X] := WellFoundedGT (Closeds X)

end PiBase
