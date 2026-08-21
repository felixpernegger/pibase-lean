module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P99.Lemmas

@[expose] public section

namespace PiBase.Formal

def P99 : Property := WellDefined.toProperty WellDefined.usSpace

end PiBase.Formal
