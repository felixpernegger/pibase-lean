module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P220.Lemmas

@[expose] public section

namespace PiBase.Formal

def P220 : Property := WellDefined.toProperty WellDefined.ultraMetrizableSpace

end PiBase.Formal
