module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P119.Lemmas

@[expose] public section

namespace PiBase.Formal

def P119 : Property := WellDefined.toProperty WellDefined.stoneanSpace

end PiBase.Formal
