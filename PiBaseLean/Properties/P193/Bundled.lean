module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P193.Lemmas

@[expose] public section

namespace PiBase.Formal

def P193 : Property := WellDefined.toProperty WellDefined.shrinkingSpace

end PiBase.Formal
