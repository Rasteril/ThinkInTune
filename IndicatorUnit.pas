unit IndicatorUnit;

interface

type
  TIndicator = class
    position: integer;
    procedure increment(amount: integer);
    procedure decrement(amount: integer);
    constructor create();
  end;

implementation

constructor TIndicator.create();
begin
  position := 1;
end;

procedure TIndicator.increment(amount: integer);
begin
  inc(position, amount);
end;

procedure TIndicator.decrement(amount: integer);
begin
  dec(position, amount);
end;


end.
