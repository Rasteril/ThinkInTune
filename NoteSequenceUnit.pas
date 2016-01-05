unit NoteSequenceUnit;

interface

uses SysUtils, Windows, Dialogs,
     CoreUnit;

type
  TNote = record
    length, height, position: integer;
  end;

  TNoteSequence = class
    sequence: array [1 .. 1000] of TNote;
    note_draw_height: integer;
    next_note_length: integer;
    procedure addNote(height: integer);
    procedure draw();
    constructor create();
  end;

implementation

uses Unit1;

constructor TNoteSequence.create();
begin
  note_draw_height := Form1.Image1.height div (MAX_NOTE_HEIGHT - MIN_NOTE_HEIGHT + 1);
  next_note_length := 1;
end;

procedure TNoteSequence.addNote(height: integer);
var
  last_note_x: integer;
  i: integer;
begin

  if next_note_length < MIN_NOTE_LENGTH then length := MIN_NOTE_LENGTH
  else if length > MAX_NOTE_LENGTH then length := MAX_NOTE_LENGTH;

  if height < MIN_NOTE_HEIGHT then height := MIN_NOTE_HEIGHT
  else if height > MAX_NOTE_HEIGHT then height := MAX_NOTE_HEIGHT;

  sequence[Indicator.position].length := next_note_length;
  sequence[Indicator.position].height := height;
  sequence[Indicator.position].position := height - MIN_NOTE_HEIGHT + 1;
  Indicator.increment(1);

  // scroll to view the new notes
  Form1.HorzScrollBar.Position := Form1.HorzScrollBar.Range;
end;

procedure TNoteSequence.draw();
var
  x, y, i, draw_cursor: integer;
begin

  {// set background
  form1.image1.canvas.brush.color := rgb(0, 0, 0);

  // clear screen
  form1.image1.canvas.rectangle(form1.image1.clientrect); }

  // set note color
  form1.image1.canvas.brush.color := rgb(107, 214, 250);
  form1.image1.canvas.pen.color := rgb(255, 255, 255);

  draw_cursor := 0;
  for i := 1 to Indicator.position do
  begin
    with Form1 do
    begin
      x := draw_cursor;
      y := image1.Height - sequence[i].position * note_draw_height;
      image1.canvas.rectangle(x, y, x + sequence[i].length * NOTE_DRAW_LENGTH, y + note_draw_height);
      inc(draw_cursor, sequence[i].length * NOTE_DRAW_LENGTH);
    end;
  end;

  Form1.image1.Canvas.Brush.color := rgb(255, 0, 0);
end;


end.
