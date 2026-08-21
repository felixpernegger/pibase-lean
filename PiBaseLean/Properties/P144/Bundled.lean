module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P144.Lemmas

@[expose] public section

namespace PiBase.Formal

def P144 : Property := WellDefined.toProperty WellDefined.locallyPseudoMetrizableSpace

end PiBase.Formal
