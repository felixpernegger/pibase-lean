module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P25.Lemmas

@[expose] public section

namespace PiBase.Formal

def P25 : Property := WellDefined.toProperty WellDefined.exhaustibleByCompacts

end PiBase.Formal
