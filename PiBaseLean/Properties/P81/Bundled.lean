module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P81.Lemmas

@[expose] public section

namespace PiBase.Formal

def P81 : Property := WellDefined.toProperty WellDefined.countablyTightSpace

end PiBase.Formal
