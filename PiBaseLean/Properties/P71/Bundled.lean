module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P71.Lemmas

@[expose] public section

namespace PiBase.Formal

def P71 : Property := WellDefined.toProperty WellDefined.sigmaRelativelyCompactSpace

end PiBase.Formal
