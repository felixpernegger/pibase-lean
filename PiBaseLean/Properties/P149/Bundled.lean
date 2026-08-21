module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P149.Lemmas

@[expose] public section

namespace PiBase.Formal

def P149 : Property := WellDefined.toProperty WellDefined.omegaLindelof

end PiBase.Formal
