module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P35.Lemmas

@[expose] public section

namespace PiBase.Formal

def P35 : Property := WellDefined.toProperty WellDefined.fullyT4Space

end PiBase.Formal
