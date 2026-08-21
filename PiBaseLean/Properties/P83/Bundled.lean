module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P83.Lemmas

@[expose] public section

namespace PiBase.Formal

def P83 : Property := WellDefined.toProperty WellDefined.metaLindelofSpace

end PiBase.Formal
