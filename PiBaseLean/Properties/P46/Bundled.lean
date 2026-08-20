module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P46.Lemmas

@[expose] public section

namespace PiBase.Formal

def P46 : Property := WellDefined.toProperty WellDefined.totallyPathDisconnectedSpace

end PiBase.Formal
