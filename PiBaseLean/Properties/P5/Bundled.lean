module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P5.Lemmas

@[expose] public section

namespace PiBase.Formal

def P5 : Property := WellDefined.toProperty WellDefined.t3Space

end PiBase.Formal
