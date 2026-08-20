module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P56.Lemmas

@[expose] public section

namespace PiBase.Formal

def P56 : Property := WellDefined.toProperty WellDefined.meagreSpace

end PiBase.Formal
