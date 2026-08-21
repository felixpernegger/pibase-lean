module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P60.Lemmas

@[expose] public section

namespace PiBase.Formal

def P60 : Property := WellDefined.toProperty WellDefined.stronglyConnectedSpace

end PiBase.Formal
