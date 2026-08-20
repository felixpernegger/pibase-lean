module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P84.Lemmas

@[expose] public section

namespace PiBase.Formal

def P84 : Property := WellDefined.toProperty WellDefined.locallyT2Space

end PiBase.Formal
