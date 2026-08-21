module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P214.Lemmas

@[expose] public section

namespace PiBase.Formal

def P214 : Property := WellDefined.toProperty WellDefined.α4Space

end PiBase.Formal
