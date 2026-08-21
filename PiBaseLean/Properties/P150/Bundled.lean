module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P150.Lemmas

@[expose] public section

namespace PiBase.Formal

def P150 : Property := WellDefined.toProperty WellDefined.omegaRothberger

end PiBase.Formal
