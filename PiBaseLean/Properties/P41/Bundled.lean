module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P41.Lemmas

@[expose] public section

namespace PiBase.Formal

def P41 : Property := WellDefined.toProperty WellDefined.locallyConnectedSpace

end PiBase.Formal
