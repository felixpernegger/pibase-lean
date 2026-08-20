module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P170.Lemmas

@[expose] public section

namespace PiBase.Formal

def P170 : Property := WellDefined.toProperty WellDefined.k1T2Space

end PiBase.Formal
