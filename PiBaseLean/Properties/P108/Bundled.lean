module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P108.Lemmas

@[expose] public section

namespace PiBase.Formal

def P108 : Property := WellDefined.toProperty WellDefined.hereditarilyCollectionwiseNormalSpace

end PiBase.Formal
