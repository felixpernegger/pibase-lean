module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P53.Lemmas

@[expose] public section

namespace PiBase.Formal

def P53 : Property := WellDefined.toProperty WellDefined.metrizableSpace

end PiBase.Formal
