module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P13.Lemmas

@[expose] public section

namespace PiBase.Formal

def P13 : Property := WellDefined.toProperty WellDefined.normalSpace

end PiBase.Formal
