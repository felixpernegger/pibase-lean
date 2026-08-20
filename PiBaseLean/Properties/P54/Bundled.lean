module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P54.Lemmas

@[expose] public section

namespace PiBase.Formal

def P54 : Property := WellDefined.toProperty WellDefined.hasSigmaLocallyFiniteBasis

end PiBase.Formal
