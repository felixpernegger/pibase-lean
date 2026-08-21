module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P80.Lemmas

@[expose] public section

namespace PiBase.Formal

def P80 : Property := WellDefined.toProperty WellDefined.frechetUrysohnSpace

end PiBase.Formal
