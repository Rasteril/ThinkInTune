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
  last_note_x, last_note_length: integer;
begin


  last_note_x := Sheet.NoteSequence.getNoteX(Sheet.NoteSequence.length);
  last_note_length := Sheet.NoteSequence.getLastNote().length;

  if (last_note_x + last_note_length * NOTE_DRAW_LENGTH) > Form1.Image1.width then
  begin
    Form1.Image1.width := last_note_x + last_note_length * NOTE_DRAW_LENGTH + 20;
  end;

  // ATTENTION when using this piece of code, hurt can be done
  Form1.Image1.Picture.Bitmap.Width := Form1.Image1.Width;
  
  // scroll to view the new notes
  Form1.HorzScrollBar.Position := Form1.HorzScrollBar.Range;

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
