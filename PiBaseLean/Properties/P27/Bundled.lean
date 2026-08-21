module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P27.Lemmas

@[expose] public section

namespace PiBase.Formal

def P27 : Property := WellDefined.toProperty WellDefined.secondCountableTopology

end PiBase.Formal
