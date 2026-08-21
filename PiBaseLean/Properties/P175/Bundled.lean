module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P175.Lemmas

@[expose] public section

namespace PiBase.Formal

def P175 : Property := WellDefined.toProperty WellDefined.cardGeThree

end PiBase.Formal
