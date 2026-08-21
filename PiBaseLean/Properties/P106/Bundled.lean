module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P106.Lemmas

@[expose] public section

namespace PiBase.Formal

def P106 : Property := WellDefined.toProperty WellDefined.hasGδDiagonal

end PiBase.Formal
