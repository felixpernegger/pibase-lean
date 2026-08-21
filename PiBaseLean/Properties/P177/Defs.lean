module

public import PiBaseLean.Properties.P117.Defs

@[expose] public section

universe u

namespace PiBase

/- 177. σ-space -/
class SigmaSpace (X : Type u) [TopologicalSpace X] : Prop extends
    T3Space X, HasSigmaLocallyFiniteNetwork X

end PiBase
