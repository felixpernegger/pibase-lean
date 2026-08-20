module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P14.Lemmas

@[expose] public section

namespace PiBase.Formal

def P14 : Property := WellDefined.toProperty WellDefined.completelyNormalSpace

end PiBase.Formal
