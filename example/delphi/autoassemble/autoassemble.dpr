program autoassemble;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmSample},
  Connector in '..\..\..\wrapper\delphi\Connector.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmSample, fmSample);
  Application.Run;
end.
