module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P105.Lemmas

@[expose] public section

namespace PiBase.Formal

def P105 : Property := WellDefined.toProperty WellDefined.paraLindelofSpace

end PiBase.Formal
