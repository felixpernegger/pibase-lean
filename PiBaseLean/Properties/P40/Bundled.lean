module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P40.Lemmas

@[expose] public section

namespace PiBase.Formal

def P40 : Property := WellDefined.toProperty WellDefined.ultraconnectedSpace

end PiBase.Formal
