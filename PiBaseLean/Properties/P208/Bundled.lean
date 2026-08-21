module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P208.Lemmas

@[expose] public section

namespace PiBase.Formal

def P208 : Property := WellDefined.toProperty WellDefined.noetherianSpace

end PiBase.Formal
