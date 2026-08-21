module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P28.Lemmas

@[expose] public section

namespace PiBase.Formal

def P28 : Property := WellDefined.toProperty WellDefined.firstCountableTopology

end PiBase.Formal
