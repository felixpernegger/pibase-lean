module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P61.Lemmas

@[expose] public section

namespace PiBase.Formal

def P61 : Property := WellDefined.toProperty WellDefined.cozeroComplementedSpace

end PiBase.Formal
