unit SheetUnit;

interface

uses Graphics, Dialogs, SysUtils,
     Core, NoteSequenceUnit, GridUnit;

type
  TSheet = class
    NoteSequence: TNoteSequence;
    Grid: TGrid;
    old_height: integer;
    old_width: integer;
    constructor create();
    procedure draw();
    procedure updateSize();
    procedure adjustSize();
    procedure addNote(length, height: integer);
  end;

implementation

uses Unit1;

constructor TSheet.create();
begin
  self.NoteSequence := TNoteSequence.create();
  self.Grid := TGrid.create();

  old_height := Form1.Image1.Height;
  old_width := Form1.Image1.Width;

  self.draw();
end;

procedure TSheet.draw();
begin
  self.Grid.draw(self.NoteSequence.note_draw_size);
  self.NoteSequence.draw();
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
    self.adjustSize();
  end;
end;

procedure TSheet.adjustSize();
var
  image_height: integer;
begin
  self.NoteSequence.note_draw_size := Form1.Image1.height div (MAX_NOTE_HEIGHT - MIN_NOTE_HEIGHT + 1);

  image_height := Form1.Image1.height;

  while (image_height div self.NoteSequence.note_draw_size) <> (MAX_NOTE_HEIGHT - MIN_NOTE_HEIGHT) do
  begin
    dec(image_height);
  end;

  Form1.Image1.height := image_height;

  self.old_height := Form1.Image1.height;

end;

procedure TSheet.addNote(length, height: integer);
begin
  self.NoteSequence.addNote(length, height);
  self.updateSize();
  self.draw();

end;


end.
