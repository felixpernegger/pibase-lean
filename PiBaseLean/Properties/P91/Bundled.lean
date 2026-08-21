module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P91.Lemmas

@[expose] public section

namespace PiBase.Formal

def P91 : Property := WellDefined.toProperty WellDefined.eberleinCompactSpace

end PiBase.Formal
