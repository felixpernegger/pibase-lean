module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P88.Lemmas

@[expose] public section

namespace PiBase.Formal

def P88 : Property := WellDefined.toProperty WellDefined.collectionwiseNormalSpace

end PiBase.Formal
