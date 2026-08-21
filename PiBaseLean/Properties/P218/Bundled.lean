module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P218.Lemmas

@[expose] public section

namespace PiBase.Formal

def P218 : Property := WellDefined.toProperty WellDefined.ultranormalSpace

end PiBase.Formal
