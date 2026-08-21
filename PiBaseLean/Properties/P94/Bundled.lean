module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P94.Lemmas

@[expose] public section

namespace PiBase.Formal

def P94 : Property := WellDefined.toProperty WellDefined.locallyFiniteSpace

end PiBase.Formal
