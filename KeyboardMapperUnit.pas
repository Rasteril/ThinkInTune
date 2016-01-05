unit KeyboardMapperUnit;

interface

uses Core;

type
  TPlayableKey = set of 1 .. 255;
  
  TKeyboardMapper = class
    map: array [0 .. 11] of integer;
    octave: integer;
    playable_keys: TPlayableKey;
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
  playable_keys := [65, 87, 83, 69, 68, 70, 84, 71, 89, 72, 85, 74];

  // TODO set or const array, one or the other, change that!

  for i := 0 to 11 do
  begin
   map[i] := KEYBOARD_MAP[i];
  end;

  octave := 5;

end;

function TKeyboardMapper.getNote(Key: Word): integer;
var
  i: integer;
begin
  for i := 0 to 11 do
  begin
    if map[i] = Key then result := i + (octave - 1) * 12;
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
