module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P139.Lemmas

@[expose] public section

namespace PiBase.Formal

def P139 : Property := WellDefined.toProperty WellDefined.hasAnIsolatedPoint

end PiBase.Formal
