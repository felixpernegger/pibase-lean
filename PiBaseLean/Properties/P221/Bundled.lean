module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P221.Lemmas

@[expose] public section

namespace PiBase.Formal

def P221 : Property := WellDefined.toProperty WellDefined.dieudonneCompleteSpace

end PiBase.Formal
