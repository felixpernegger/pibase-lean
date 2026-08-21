module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P92.Lemmas

@[expose] public section

namespace PiBase.Formal

def P92 : Property := WellDefined.toProperty WellDefined.kω3Space

end PiBase.Formal
