module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P178.Lemmas

@[expose] public section

namespace PiBase.Formal

def P178 : Property := WellDefined.toProperty WellDefined.alephSpace

end PiBase.Formal
