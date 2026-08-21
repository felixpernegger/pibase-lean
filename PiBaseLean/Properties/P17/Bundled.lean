module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P17.Lemmas

@[expose] public section

namespace PiBase.Formal

def P17 : Property := WellDefined.toProperty WellDefined.sigmaCompactSpace

end PiBase.Formal
