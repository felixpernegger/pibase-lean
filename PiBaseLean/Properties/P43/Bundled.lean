module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P43.Lemmas

@[expose] public section

namespace PiBase.Formal

def P43 : Property := WellDefined.toProperty WellDefined.locallyInjPathConnectedSpace

end PiBase.Formal
