module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P113.Lemmas

@[expose] public section

namespace PiBase.Formal

def P113 : Property := WellDefined.toProperty WellDefined.mooreSpace

end PiBase.Formal
