module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P97.Lemmas

@[expose] public section

namespace PiBase.Formal

def P97 : Property := WellDefined.toProperty WellDefined.embeddableInR

end PiBase.Formal
