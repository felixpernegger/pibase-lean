module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P192.Lemmas

@[expose] public section

namespace PiBase.Formal

def P192 : Property := WellDefined.toProperty WellDefined.quasiSober

end PiBase.Formal
