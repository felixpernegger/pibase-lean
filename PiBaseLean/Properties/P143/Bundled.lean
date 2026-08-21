module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P143.Lemmas

@[expose] public section

namespace PiBase.Formal

def P143 : Property := WellDefined.toProperty WellDefined.weakT2Space

end PiBase.Formal
