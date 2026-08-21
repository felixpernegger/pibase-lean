module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P74.Lemmas

@[expose] public section

namespace PiBase.Formal

def P74 : Property := WellDefined.toProperty WellDefined.cosmicSpace

end PiBase.Formal
