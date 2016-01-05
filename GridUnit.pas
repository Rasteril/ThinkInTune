unit GridUnit;

interface

uses Windows, SysUtils, Dialogs,
     CoreUnit;

type
  TGrid = class
    constructor create();
    procedure draw(note_draw_size: integer);
  end;

implementation

uses Unit1;

constructor TGrid.create();
begin

end;

procedure TGrid.draw(note_draw_size: integer);
var
  cell_height: integer;
  i, x, y: integer;
begin
  // TODO Fix Grid
  cell_height := 12 * note_draw_size;
  for i := 0 to OCTAVE_COUNT - 1 do
  begin
    x := 0;
    y := i * cell_height;

    //showmessage(inttostr(i) + ' ' + inttostr(i * cell_height));
    //showmessage('One octave should be ' + inttostr(12 * note_draw_size));
    if (i mod 2) = 0 then
    begin
      GraphicsManager.rectangle(x, y, x + Form1.Image1.Width, y + cell_height, rgb(0, 0, 0));
    end

    else
    begin
      GraphicsManager.rectangle(x, y, x + Form1.Image1.Width, y + cell_height, rgb(20, 20, 20));
    end;

  end;
end;


end.
