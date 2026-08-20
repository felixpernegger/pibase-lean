module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P135.Lemmas

@[expose] public section

namespace PiBase.Formal

def P135 : Property := WellDefined.toProperty WellDefined.r0Space

end PiBase.Formal
