module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P18.Lemmas

@[expose] public section

namespace PiBase.Formal

def P18 : Property := WellDefined.toProperty WellDefined.lindelofSpace

end PiBase.Formal
