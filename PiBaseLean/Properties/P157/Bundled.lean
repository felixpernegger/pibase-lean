module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P157.Lemmas

@[expose] public section

namespace PiBase.Formal

def P157 : Property := WellDefined.toProperty WellDefined.strategicallyKRothbergerSpace

end PiBase.Formal
