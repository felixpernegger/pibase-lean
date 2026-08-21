module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P191.Lemmas

@[expose] public section

namespace PiBase.Formal

def P191 : Property := WellDefined.toProperty WellDefined.hasGδSingletons

end PiBase.Formal
