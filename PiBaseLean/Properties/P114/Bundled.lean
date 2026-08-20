module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P114.Lemmas

@[expose] public section

namespace PiBase.Formal

def P114 : Property := WellDefined.toProperty WellDefined.cardEqAlephOne

end PiBase.Formal
