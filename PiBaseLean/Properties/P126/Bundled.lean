module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P126.Lemmas

@[expose] public section

namespace PiBase.Formal

def P126 : Property := WellDefined.toProperty WellDefined.doorSpace

end PiBase.Formal
