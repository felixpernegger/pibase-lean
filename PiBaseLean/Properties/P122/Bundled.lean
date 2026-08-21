module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P122.Lemmas

@[expose] public section

namespace PiBase.Formal

def P122 : Property := WellDefined.toProperty WellDefined.locallyEuclideanSpace

end PiBase.Formal
