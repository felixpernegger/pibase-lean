module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P100.Lemmas

@[expose] public section

namespace PiBase.Formal

def P100 : Property := WellDefined.toProperty WellDefined.kcSpace

end PiBase.Formal
