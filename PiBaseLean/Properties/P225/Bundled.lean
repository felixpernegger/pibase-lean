module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P225.Lemmas

@[expose] public section

namespace PiBase.Formal

def P225 : Property := WellDefined.toProperty WellDefined.lCSpace

end PiBase.Formal
