module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P134.Lemmas

@[expose] public section

namespace PiBase.Formal

def P134 : Property := WellDefined.toProperty WellDefined.r1Space

end PiBase.Formal
