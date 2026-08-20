module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P182.Lemmas

@[expose] public section

namespace PiBase.Formal

def P182 : Property := WellDefined.toProperty WellDefined.hasCountableNetwork

end PiBase.Formal
