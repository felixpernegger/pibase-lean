module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P3.Lemmas

@[expose] public section

namespace PiBase.Formal

def P3 : Property := WellDefined.toProperty WellDefined.t2Space

end PiBase.Formal
