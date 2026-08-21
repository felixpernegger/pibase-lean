module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P110.Lemmas

@[expose] public section

namespace PiBase.Formal

def P110 : Property := WellDefined.toProperty WellDefined.developableSpace

end PiBase.Formal
