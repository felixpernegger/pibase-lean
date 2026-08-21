module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P9.Lemmas

@[expose] public section

namespace PiBase.Formal

def P9 : Property := WellDefined.toProperty WellDefined.functionallyT2Space

end PiBase.Formal
