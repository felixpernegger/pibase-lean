module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P75.Lemmas

@[expose] public section

namespace PiBase.Formal

def P75 : Property := WellDefined.toProperty WellDefined.spectralSpace

end PiBase.Formal
