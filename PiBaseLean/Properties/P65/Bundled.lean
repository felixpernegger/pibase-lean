module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P65.Lemmas

@[expose] public section

namespace PiBase.Formal

def P65 : Property := WellDefined.toProperty WellDefined.cardEqContinuum

end PiBase.Formal
