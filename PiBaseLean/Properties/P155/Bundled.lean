module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P155.Lemmas

@[expose] public section

namespace PiBase.Formal

def P155 : Property := WellDefined.toProperty WellDefined.locallyOneEuclideanSpace

end PiBase.Formal
