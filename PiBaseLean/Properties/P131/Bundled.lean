module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P131.Lemmas

@[expose] public section

namespace PiBase.Formal

def P131 : Property := WellDefined.toProperty WellDefined.hereditarilyLindelofSpace

end PiBase.Formal
