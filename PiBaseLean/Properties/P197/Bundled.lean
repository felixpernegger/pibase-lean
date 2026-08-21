module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P197.Lemmas

@[expose] public section

namespace PiBase.Formal

def P197 : Property := WellDefined.toProperty WellDefined.hasCountableSpread

end PiBase.Formal
