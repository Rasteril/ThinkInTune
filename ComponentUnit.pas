unit ComponentUnit;

interface

uses Math, Windows, Graphics, Dialogs, SysUtils,
     CoreUnit;

type
  TSheet = class; // dummy class



  TNoteSequence = class
    sequence: array [1 .. 1000] of TNote;
    note_draw_height: integer;
    next_note_length: integer;
    length: integer;
    procedure addNote(height: integer);
    function getNote(position: integer): TNote;
    function getNoteX(position: integer): integer;
    function getLastNote(): TNote;
    procedure draw();
    constructor create(parent: TSheet);

    private
      Parent: TSheet;
  end;

  TGrid = class
    constructor create(parent: TSheet);
    procedure draw(note_draw_height: integer);

    private
      Parent: TSheet;
  end;

  TIndicator = class
    position: integer;
    procedure increment(amount: integer);
    procedure decrement(amount: integer);
    procedure draw();
    constructor create(parent: TSheet);

    private
      Parent: TSheet;
  end;

  TSheet = class
    NoteSequence: TNoteSequence;
    Indicator: TIndicator;
    Grid: TGrid;
    old_height: integer;
    old_width: integer;
    constructor create();
    procedure draw();
    procedure updateSize();
    procedure adjustHeight();
    procedure addNote(height: integer);
  end;

implementation

uses Unit1;

{ *************** TSheet *************** }

constructor TSheet.create();
begin
  self.NoteSequence := TNoteSequence.create(self);
  self.Grid := TGrid.create(self);
  self.Indicator := TIndicator.create(self);

  old_height := Form1.Image1.Height;
  old_width := Form1.Image1.Width;

  self.draw();
end;

procedure TSheet.draw();
begin
  self.Grid.draw(self.NoteSequence.note_draw_height);
  self.NoteSequence.draw();
  self.Indicator.draw();
end;

procedure TSheet.updateSize();
var
  image_height: integer;
  last_note_x: integer;
  i: integer;
begin

  // Notes past available canvas
  //if old_width <> self.old_width then
  begin
    GraphicsManager.updateCanvasWidth();
    self.old_width := Form1.Image1.Width;
  end;

  // If vertical scale
  if self.old_height <> Form1.Image1.height then
  begin
    self.adjustHeight();
  end;
end;

procedure TSheet.adjustHeight();
var
  image_height: integer;
begin
  self.NoteSequence.note_draw_height := Form1.Image1.height div (MAX_NOTE_HEIGHT - MIN_NOTE_HEIGHT + 1);

  image_height := Form1.Image1.height;

  while (image_height div self.NoteSequence.note_draw_height) <> (MAX_NOTE_HEIGHT - MIN_NOTE_HEIGHT) do
  begin
    dec(image_height);
  end;

  Form1.Image1.height := image_height;

  self.old_height := Form1.Image1.height;

end;

procedure TSheet.addNote(height: integer);
begin
  self.NoteSequence.addNote(height);
  self.updateSize();
  self.draw();
end;

{ *************** TNoteSequence *************** }

constructor TNoteSequence.create(parent: TSheet);
begin
  note_draw_height := Form1.Image1.height div (MAX_NOTE_HEIGHT - MIN_NOTE_HEIGHT + 1);
  next_note_length := 1;

  length := 0;
  self.Parent := parent;
end;

procedure TNoteSequence.addNote(height: integer);
var
  last_note_x: integer;
  i: integer;
  pos: integer;
begin

  if self.next_note_length < MIN_NOTE_LENGTH then self.next_note_length := MIN_NOTE_LENGTH
  else if self.next_note_length > MAX_NOTE_LENGTH then self.next_note_length := MAX_NOTE_LENGTH;

  if height < MIN_NOTE_HEIGHT then height := MIN_NOTE_HEIGHT
  else if height > MAX_NOTE_HEIGHT then height := MAX_NOTE_HEIGHT;

  pos := Parent.Indicator.position + 1;

  sequence[pos].length := self.next_note_length;
  sequence[pos].height := height;
  sequence[pos].vert_position := height - MIN_NOTE_HEIGHT + 1;
  sequence[pos].horiz_position := Parent.Indicator.position;

  //showmessage('Parent.Indicator.position: ' + inttostr(Parent.Indicator.position));

  if length >= 1 then
  begin
    sequence[pos].x := self.next_note_length * NOTE_DRAW_LENGTH + sequence[pos - 1].x;
  end

  else
  begin
    sequence[pos].x := self.next_note_length * NOTE_DRAW_LENGTH;
  end;


  if Parent.Indicator.position = self.length then
  begin
    inc(self.length);
  end;

  Parent.Indicator.increment(1);

end;

procedure TNoteSequence.draw();
var
  x, y, i, draw_cursor: integer;
begin

  // set note color
  form1.image1.canvas.brush.color := rgb(107, 214, 250);
  form1.image1.canvas.pen.color := rgb(255, 255, 255);

  draw_cursor := 0;
  for i := 1 to self.length do
  begin
    with Form1 do
    begin
      x := draw_cursor;
      y := image1.Height - sequence[i].vert_position * note_draw_height;
      image1.canvas.rectangle(x, y, x + sequence[i].length * NOTE_DRAW_LENGTH, y + note_draw_height);
      inc(draw_cursor, sequence[i].length * NOTE_DRAW_LENGTH);
    end;
  end;

  Form1.image1.Canvas.Brush.color := rgb(255, 0, 0);
end;

function TNoteSequence.getNote(position: integer): TNote;
begin
  result := sequence[position];
end;

function TNoteSequence.getNoteX(position: integer): integer;
var
  i, x: integer;
begin
  x := 0;

  if self.length >= position then
  begin
    for i := 1 to position do
    begin
      inc(x, self.sequence[i].length * NOTE_DRAW_LENGTH);
    end;
  end;

  result := x;
end;


function TNoteSequence.getLastNote(): TNote;
begin
  result := self.getNote(length);
end;

{ *************** TGrid *************** }

constructor TGrid.create(parent: TSheet);
begin
  self.Parent := parent;
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
  bar_count := ceil(Form1.Image1.width / cell_width);

  for j := 0 to bar_count - 1 do
  begin
    x := j * cell_width;
    y := 0;

    GraphicsManager.line(x, y, x, y + Form1.Image1.Height, rgb(50, 50, 50));
  end;
end;

{ *************** TIndicator *************** }

constructor TIndicator.create(parent: TSheet);
begin
  self.Parent := parent;
  self.position := 0;
end;

procedure TIndicator.increment(amount: integer);
begin
  if Parent.NoteSequence.length >= self.position + amount then
  begin
    inc(self.position, amount);
  end;
end;

procedure TIndicator.decrement(amount: integer);
begin
  if self.position - amount > 0 then
  begin
    dec(self.position, amount);
  end;
end;

procedure TIndicator.draw();
var
  x, y: integer;
  i: integer;
begin
  x := 0;
  y := 0;

  if Parent.NoteSequence.length >= 1 then
  begin
      x := Parent.NoteSequence.getNoteX(self.position);
  end;

  GraphicsManager.line(x, y, x, y + Form1.Image1.height, rgb(255, 0, 0));
end;




end.
