module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P207.Lemmas

@[expose] public section

namespace PiBase.Formal

def P207 : Property := WellDefined.toProperty WellDefined.stronglyCollectionwiseNormalSpace

end PiBase.Formal
