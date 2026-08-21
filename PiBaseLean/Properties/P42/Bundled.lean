module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P42.Lemmas

@[expose] public section

namespace PiBase.Formal

def P42 : Property := WellDefined.toProperty WellDefined.locallyPathConnectedSpace

end PiBase.Formal
