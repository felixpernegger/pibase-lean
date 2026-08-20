module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P31.Lemmas

@[expose] public section

namespace PiBase.Formal

def P31 : Property := WellDefined.toProperty WellDefined.metacompactSpace

end PiBase.Formal
