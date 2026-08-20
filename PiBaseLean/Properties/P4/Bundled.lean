module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P4.Lemmas

@[expose] public section

namespace PiBase.Formal

def P4 : Property := WellDefined.toProperty WellDefined.t25Space

end PiBase.Formal
