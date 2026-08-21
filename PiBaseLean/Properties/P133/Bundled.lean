module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P133.Lemmas

@[expose] public section

namespace PiBase.Formal

def P133 : Property := WellDefined.toProperty WellDefined.lots

end PiBase.Formal
