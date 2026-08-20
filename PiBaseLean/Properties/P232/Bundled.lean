module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P232.Lemmas

@[expose] public section

namespace PiBase.Formal

def P232 : Property := WellDefined.toProperty WellDefined.lC1

end PiBase.Formal
