module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P147.Lemmas

@[expose] public section

namespace PiBase.Formal

def P147 : Property := WellDefined.toProperty WellDefined.pSpace

end PiBase.Formal
