module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P130.Lemmas

@[expose] public section

namespace PiBase.Formal

def P130 : Property := WellDefined.toProperty WellDefined.locallyCompactSpace

end PiBase.Formal
