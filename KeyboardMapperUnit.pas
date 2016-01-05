unit KeyboardMapperUnit;

interface

uses CoreUnit;

type
  TKey = set of 1 .. 255;
  TKeyboardNumber = set of 1 .. 9;
  
  TKeyboardMapper = class
    map: array [0 .. 11] of integer;
    octave: integer;
    playable_keys: TKey;
    set_length_keys: TKey;
    set_length_numbers: TKeyboardNumber;
    function getNote(key: Word): integer;
    function getKey(note: integer): integer;
    procedure setOctave(value: integer);
    constructor create();
  end;



const
   KEYBOARD_MAP: array[0 .. 11] of integer = (65, 87, 83, 69, 68, 70, 84, 71, 89, 72, 85, 74);

implementation

constructor TKeyboardMapper.create();
var
  i: integer;
begin
  self.playable_keys := [65, 87, 83, 69, 68, 70, 84, 71, 89, 72, 85, 74];
  self.set_length_keys := [48 .. 57];
  self.set_length_numbers := [1 .. 9];

  // TODO set or const array, one or the other, change that!

  for i := 0 to 11 do
  begin
   self.map[i] := KEYBOARD_MAP[i];
  end;

  self.octave := 5;

end;

function TKeyboardMapper.getNote(Key: Word): integer;
var
  i: integer;
begin
  for i := 0 to 11 do
  begin
    if self.map[i] = Key then result := i + (self.octave - 1) * 12;
  end;
end;

function TKeyboardMapper.getKey(note: integer): integer;
begin
  result := map[note - octave * 12];
end;

procedure TKeyboardMapper.setOctave(value: integer);
begin
  if value < MIN_OCTAVE then value := MIN_OCTAVE
  else if value > MAX_OCTAVE then value := MAX_OCTAVE;

  octave := value;
end;


end.
