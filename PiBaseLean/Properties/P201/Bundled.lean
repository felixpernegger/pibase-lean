module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P201.Lemmas

@[expose] public section

namespace PiBase.Formal

def P201 : Property := WellDefined.toProperty WellDefined.hasGenericPoint

end PiBase.Formal
