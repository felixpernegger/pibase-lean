module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P240.Lemmas

@[expose] public section

namespace PiBase.Formal

def P240 : Property := WellDefined.toProperty WellDefined.cWComplexSpace

end PiBase.Formal
