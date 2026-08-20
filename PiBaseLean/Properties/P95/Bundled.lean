module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P95.Lemmas

@[expose] public section

namespace PiBase.Formal

def P95 : Property := WellDefined.toProperty WellDefined.arcConnectedSpace

end PiBase.Formal
