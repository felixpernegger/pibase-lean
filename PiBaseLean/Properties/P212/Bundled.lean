module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P212.Lemmas

@[expose] public section

namespace PiBase.Formal

def P212 : Property := WellDefined.toProperty WellDefined.α2Space

end PiBase.Formal
