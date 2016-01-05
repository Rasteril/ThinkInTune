unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,

  CoreUnit, SheetUnit, GridUnit, IndicatorUnit, KeyboardMapperUnit, MidiUtilitiesUnit, NoteSequenceUnit, GraphicsManagerUnit;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    last_pressed_key: integer;
    key_down: boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  KeyboardMapper: TKeyboardMapper;
  Indicator: TIndicator;
  Sheet: TSheet;
  GraphicsManager: TGraphicsManager;
  old_form_height, old_form_width: integer;


implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  InitMIDI;
  SetInstrument(93);

  key_down := false; // At this time, only one key at a time can be pressed

  Image1.height := self.height - 50;
  Image1.Width := self.width - 50; // same as in FormResize (so that no change)

  old_form_width := self.Width;
  old_form_height := self.Height;

  KeyboardMapper := TKeyboardMapper.create();
  Indicator := TIndicator.create();
  Sheet := TSheet.create();
  GraphicsManager := TGraphicsManager.create();

  Sheet.adjustHeight();


end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if not key_down then
  begin
    key_down := True;

    if (Key = VK_DOWN) then
    begin
      KeyboardMapper.setOctave(KeyboardMapper.octave - 1);
    end

    else if (Key = VK_UP) then
    begin
      KeyboardMapper.setOctave(KeyboardMapper.octave + 1);
    end

    else if Key in KeyboardMapper.set_length_keys then
    begin

    end

    else
    begin

      if Key in KeyboardMapper.playable_keys then
      begin
        self.last_pressed_key := Key;

        NoteOn(KeyboardMapper.getNote(Key), INTENSITY);
        Timer1.Interval := 100;
        Timer1.Enabled := True;
        //sleep(100 * Sheet.NoteSequence.next_note_length);

      end;
    end;
  end;

end;

procedure TForm1.FormResize(Sender: TObject);
var
  image_height: integer;
begin
  // ATTENTION, this fires on start, also when nothing has been resized

  {showmessage('Old_image_height: ' + inttostr(old_form_height));
  showmessage('Old_image_width: ' + inttostr(old_form_width));
  showmessage('Image1.height: ' + inttostr(self.Height));
  showmessage('Image1.width: ' + inttostr(self.width)); }

  if (old_form_width <> self.width) or (old_form_height <> self.height) then
  begin

    Image1.height := self.height - 50;

    if Sheet.old_width < self.width - 50 then
    begin
      //Image1.Width := self.width - 50;
      // TODO Fix Scrolling fail
    end;

    // this neat trick helps resize the canvas beyond the creation size
    Image1.Picture.Bitmap.Height := Image1.Height;
    Image1.Picture.Bitmap.Width := Image1.Width;

    Sheet.updateSize();
    Sheet.draw();

    old_form_width := self.Width;
    old_form_height := self.Height;
  end;

end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
  int_key: integer;
begin
  try
    int_key := strtoint(Key);
  except
    on E: Exception do
    begin
      // warn through a status message
    end;
  end;

  if int_key in KeyboardMapper.set_length_numbers then
  begin
    Sheet.NoteSequence.next_note_length := int_key;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

  NoteOff(KeyboardMapper.getNote(self.last_pressed_key), INTENSITY);

  Sheet.addNote(KeyboardMapper.getNote(self.last_pressed_key));

  Timer1.Enabled := False;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key_down := False;
end;

end.


