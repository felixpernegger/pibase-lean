module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P209.Lemmas

@[expose] public section

namespace PiBase.Formal

def P209 : Property := WellDefined.toProperty WellDefined.densityLeContinuum

end PiBase.Formal
