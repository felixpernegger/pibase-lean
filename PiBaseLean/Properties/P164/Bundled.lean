module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P164.Lemmas

@[expose] public section

namespace PiBase.Formal

def P164 : Property := WellDefined.toProperty WellDefined.cardLtEveryMeasurableCardinal

end PiBase.Formal
