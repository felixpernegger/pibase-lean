module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P148.Lemmas

@[expose] public section

namespace PiBase.Formal

def P148 : Property := WellDefined.toProperty WellDefined.cWGH

end PiBase.Formal
