module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P236.Lemmas

@[expose] public section

namespace PiBase.Formal

def P236 : Property := WellDefined.toProperty WellDefined.locallyNEuclideanHalfSpace

end PiBase.Formal
