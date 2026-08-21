module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P107.Lemmas

@[expose] public section

namespace PiBase.Formal

def P107 : Property := WellDefined.toProperty WellDefined.hasClosedPoint

end PiBase.Formal
