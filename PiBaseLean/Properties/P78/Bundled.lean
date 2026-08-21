module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P78.Lemmas

@[expose] public section

namespace PiBase.Formal

def P78 : Property := WellDefined.toProperty WellDefined.finite

end PiBase.Formal
