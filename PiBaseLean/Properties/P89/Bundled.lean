module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P89.Lemmas

@[expose] public section

namespace PiBase.Formal

def P89 : Property := WellDefined.toProperty WellDefined.fixedPointSpace

end PiBase.Formal
