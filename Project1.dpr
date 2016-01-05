program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MidiUtilitiesUnit in 'MidiUtilitiesUnit.pas',
  KeyboardMapperUnit in 'KeyboardMapperUnit.pas',
  CoreUnit in 'CoreUnit.pas',
  SheetUnit in 'SheetUnit.pas',
  GraphicsManagerUnit in 'GraphicsManagerUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
