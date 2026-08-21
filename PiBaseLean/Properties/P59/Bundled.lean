module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P59.Lemmas

@[expose] public section

namespace PiBase.Formal

def P59 : Property := WellDefined.toProperty WellDefined.cardLePowerContinuum

end PiBase.Formal
