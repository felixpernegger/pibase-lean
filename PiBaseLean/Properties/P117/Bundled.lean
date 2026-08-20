module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P117.Lemmas

@[expose] public section

namespace PiBase.Formal

def P117 : Property := WellDefined.toProperty WellDefined.hasSigmaLocallyFiniteNetwork

end PiBase.Formal
