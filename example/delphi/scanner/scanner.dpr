program scanner;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmScanner},
  Connector in '..\..\..\wrapper\delphi\Connector.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmScanner, fmScanner);
  Application.Run;
end.
