module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P211.Lemmas

@[expose] public section

namespace PiBase.Formal

def P211 : Property := WellDefined.toProperty WellDefined.α15Space

end PiBase.Formal
