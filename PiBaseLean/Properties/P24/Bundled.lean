module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P24.Lemmas

@[expose] public section

namespace PiBase.Formal

def P24 : Property := WellDefined.toProperty WellDefined.locallyRelativelyCompactSpace

end PiBase.Formal
