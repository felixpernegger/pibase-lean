module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P176.Lemmas

@[expose] public section

namespace PiBase.Formal

def P176 : Property := WellDefined.toProperty WellDefined.cardGeFour

end PiBase.Formal
