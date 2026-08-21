module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P36.Lemmas

@[expose] public section

namespace PiBase.Formal

def P36 : Property := WellDefined.toProperty WellDefined.preconnectedSpace

end PiBase.Formal
