unit GridUnit;

interface

uses Windows, SysUtils, Dialogs,
     CoreUnit;

type
  TGrid = class
    constructor create();
    procedure draw(note_draw_height: integer);
  end;

implementation

uses Unit1;

constructor TGrid.create();
begin

end;

procedure TGrid.draw(note_draw_height: integer);
var
  cell_width, cell_height: integer;
  bar_count: integer;
  i, j, x, y: integer;
begin

  // vertical grid (octaves)
  cell_height := 12 * note_draw_height;
  for i := 0 to OCTAVE_COUNT - 1 do
  begin
    x := 0;
    y := i * cell_height;

    if (i mod 2) = 0 then
    begin
      GraphicsManager.rectangle(x, y, x + Form1.Image1.Width, y + cell_height, rgb(0, 0, 0));
    end

    else
    begin
      GraphicsManager.rectangle(x, y, x + Form1.Image1.Width, y + cell_height, rgb(20, 20, 20));
    end;
  end;

  //horizontal grid (bars)
  cell_width := 4 * NOTE_DRAW_LENGTH;
  bar_count := Form1.Image1.width div cell_width;

  for j := 0 to bar_count - 1 do
  begin
    x := j * cell_width;
    y := 0;

    GraphicsManager.line(x, y, x, y + Form1.Image1.Height, rgb(50, 50, 50));
  end;
end;


end.
