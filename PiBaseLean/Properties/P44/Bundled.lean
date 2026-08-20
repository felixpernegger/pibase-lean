module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P44.Lemmas

@[expose] public section

namespace PiBase.Formal

def P44 : Property := WellDefined.toProperty WellDefined.biconnectedSpace

end PiBase.Formal
