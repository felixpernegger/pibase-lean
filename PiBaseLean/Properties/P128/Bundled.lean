module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P128.Lemmas

@[expose] public section

namespace PiBase.Formal

def P128 : Property := WellDefined.toProperty WellDefined.kLindelofSpace

end PiBase.Formal
