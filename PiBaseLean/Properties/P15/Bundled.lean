module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P15.Lemmas

@[expose] public section

namespace PiBase.Formal

def P15 : Property := WellDefined.toProperty WellDefined.perfectlyNormalSpace

end PiBase.Formal
