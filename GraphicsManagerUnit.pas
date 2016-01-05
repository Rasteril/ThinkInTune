unit GraphicsManagerUnit;

interface

uses Graphics, Dialogs;

type
  TGraphicsManager = class
    constructor create();
    procedure updateCanvasWidth();
    procedure rectangle(x1, y1, x2, y2: integer; color: TColor);
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
    showmessage(inttostr(Indicator.position));
    for i := 1 to Indicator.position do
    begin
      inc(last_note_x, Sheet.NoteSequence.sequence[i].length);
    end;

    if last_note_x + Sheet.NoteSequence.note_draw_height > Form1.Image1.width then
    begin
      Form1.Image1.width := last_note_x + 20;
    end;
  end;

end;

procedure TGraphicsManager.rectangle(x1, y1, x2, y2: integer; color: TColor);
begin
  Form1.Image1.Canvas.brush.Color := color;
  Form1.Image1.Canvas.pen.color := color;
  Form1.Image1.Canvas.Rectangle(x1, y1, x2, y2);

  Form1.Image1.Canvas.brush.Color := clGreen;

end;

end.
