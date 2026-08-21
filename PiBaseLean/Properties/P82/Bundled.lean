module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P82.Lemmas

@[expose] public section

namespace PiBase.Formal

def P82 : Property := WellDefined.toProperty WellDefined.locallyMetrizableSpace

end PiBase.Formal
