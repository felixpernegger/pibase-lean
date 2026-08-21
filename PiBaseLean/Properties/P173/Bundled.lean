module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P173.Lemmas

@[expose] public section

namespace PiBase.Formal

def P173 : Property := WellDefined.toProperty WellDefined.pseudoradialSpace

end PiBase.Formal
