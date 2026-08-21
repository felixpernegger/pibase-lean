module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P163.Lemmas

@[expose] public section

namespace PiBase.Formal

def P163 : Property := WellDefined.toProperty WellDefined.cardLeContinuum

end PiBase.Formal
