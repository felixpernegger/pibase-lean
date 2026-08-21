module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P2.Lemmas

@[expose] public section

namespace PiBase.Formal

def P2 : Property := WellDefined.toProperty WellDefined.t1Space

end PiBase.Formal
