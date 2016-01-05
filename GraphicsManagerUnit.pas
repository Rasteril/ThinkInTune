unit GraphicsManagerUnit;

interface

uses Graphics, Dialogs, SysUtils,
     CoreUnit;

type
  TGraphicsManager = class
    constructor create();
    procedure updateCanvasWidth();
    procedure rectangle(x1, y1, x2, y2: integer; color: TColor);
    procedure line(x1, y1, x2, y2: integer; color: TColor);
  end;

implementation

uses Unit1;

constructor TGraphicsManager.create();
begin

end;

procedure TGraphicsManager.updateCanvasWidth();
var
  i, last_note_x: integer;
begin
  // ATTENTION when using this piece of code, hurt can be done
  Form1.Image1.Picture.Bitmap.Width := Form1.Image1.Width;

  last_note_x := 0;

  if length(Sheet.NoteSequence.sequence) > 0 then
  begin
    for i := 1 to Indicator.position do
    begin
      inc(last_note_x, Sheet.NoteSequence.sequence[i].length * NOTE_DRAW_LENGTH);
    end;

    if (last_note_x + Sheet.NoteSequence.sequence[i].length * NOTE_DRAW_LENGTH) > Form1.Image1.width then
    begin
      Form1.Image1.width := last_note_x + Sheet.NoteSequence.sequence[i].length * NOTE_DRAW_LENGTH + 20;
    end;
  end;

end;

procedure TGraphicsManager.rectangle(x1, y1, x2, y2: integer; color: TColor);
begin
  with Form1.Image1.Canvas do
  begin
    brush.Color := color;
    pen.color := color;
    Rectangle(x1, y1, x2, y2);
    brush.Color := clGreen;
  end;
end;

procedure TGraphicsManager.line(x1, y1, x2, y2: integer; color: TColor);
begin
  with Form1.Image1.Canvas do
  begin
    pen.color := color;
    MoveTo(x1, y1);
    Lineto(x2, y2);
  end;
end;

end.
