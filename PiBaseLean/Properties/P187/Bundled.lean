module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P187.Lemmas

@[expose] public section

namespace PiBase.Formal

def P187 : Property := WellDefined.toProperty WellDefined.wSpace

end PiBase.Formal
