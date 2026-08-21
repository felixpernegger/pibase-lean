module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P67.Lemmas

@[expose] public section

namespace PiBase.Formal

def P67 : Property := WellDefined.toProperty WellDefined.t6Space

end PiBase.Formal
