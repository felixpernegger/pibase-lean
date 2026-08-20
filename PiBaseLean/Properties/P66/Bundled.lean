module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P66.Lemmas

@[expose] public section

namespace PiBase.Formal

def P66 : Property := WellDefined.toProperty WellDefined.mengerSpace

end PiBase.Formal
