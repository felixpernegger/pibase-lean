module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P62.Lemmas

@[expose] public section

namespace PiBase.Formal

def P62 : Property := WellDefined.toProperty WellDefined.weaklyLindelofSpace

end PiBase.Formal
