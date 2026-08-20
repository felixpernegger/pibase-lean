module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P241.Lemmas

@[expose] public section

namespace PiBase.Formal

def P241 : Property := WellDefined.toProperty WellDefined.locallyEuclideanHalfLine

end PiBase.Formal
