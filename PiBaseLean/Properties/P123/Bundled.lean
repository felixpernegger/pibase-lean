module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P123.Lemmas

@[expose] public section

namespace PiBase.Formal

def P123 : Property := WellDefined.toProperty WellDefined.locallyNEuclideanSpace

end PiBase.Formal
