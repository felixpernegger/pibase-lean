module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P235.Lemmas

@[expose] public section

namespace PiBase.Formal

def P235 : Property := WellDefined.toProperty WellDefined.locallyEuclideanHalfSpace

end PiBase.Formal
