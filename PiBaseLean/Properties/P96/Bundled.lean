module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P96.Lemmas

@[expose] public section

namespace PiBase.Formal

def P96 : Property := WellDefined.toProperty WellDefined.locallyArcConnectedSpace

end PiBase.Formal
