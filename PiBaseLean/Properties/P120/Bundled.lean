module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P120.Lemmas

@[expose] public section

namespace PiBase.Formal

def P120 : Property := WellDefined.toProperty WellDefined.locallyOrderableSpace

end PiBase.Formal
