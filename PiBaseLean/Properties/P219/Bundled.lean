module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P219.Lemmas

@[expose] public section

namespace PiBase.Formal

def P219 : Property := WellDefined.toProperty WellDefined.torontoSpace

end PiBase.Formal
