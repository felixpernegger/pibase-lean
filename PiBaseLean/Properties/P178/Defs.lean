module

public import PiBaseLean.Properties.P118.Defs

@[expose] public section

universe u

namespace PiBase

/- 178. ℵ-space -/
class AlephSpace (X : Type u) [TopologicalSpace X] : Prop extends
    T3Space X, HasSigmaLocallyFiniteKNetwork X

end PiBase
