module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P58.Lemmas

@[expose] public section

namespace PiBase.Formal

def P58 : Property := WellDefined.toProperty WellDefined.cardLtContinuum

end PiBase.Formal
