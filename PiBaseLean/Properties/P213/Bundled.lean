module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P213.Lemmas

@[expose] public section

namespace PiBase.Formal

def P213 : Property := WellDefined.toProperty WellDefined.α3Space

end PiBase.Formal
