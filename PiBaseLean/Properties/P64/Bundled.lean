module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P64.Lemmas

@[expose] public section

namespace PiBase.Formal

def P64 : Property := WellDefined.toProperty WellDefined.baireSpace

end PiBase.Formal
