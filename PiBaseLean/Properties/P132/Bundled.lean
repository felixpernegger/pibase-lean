module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P132.Lemmas

@[expose] public section

namespace PiBase.Formal

def P132 : Property := WellDefined.toProperty WellDefined.gδSpace

end PiBase.Formal
