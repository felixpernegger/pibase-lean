module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P1.Lemmas

@[expose] public section

namespace PiBase.Formal

def P1 : Property := WellDefined.toProperty WellDefined.t0Space

end PiBase.Formal
