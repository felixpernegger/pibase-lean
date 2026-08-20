module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P93.Lemmas

@[expose] public section

namespace PiBase.Formal

def P93 : Property := WellDefined.toProperty WellDefined.locallyCountableSpace

end PiBase.Formal
