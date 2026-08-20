module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P23.Lemmas

@[expose] public section

namespace PiBase.Formal

def P23 : Property := WellDefined.toProperty WellDefined.weaklyLocallyCompactSpace

end PiBase.Formal
