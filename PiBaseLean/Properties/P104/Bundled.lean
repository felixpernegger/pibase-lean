module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P104.Lemmas

@[expose] public section

namespace PiBase.Formal

def P104 : Property := WellDefined.toProperty WellDefined.symmetrizableSpace

end PiBase.Formal
