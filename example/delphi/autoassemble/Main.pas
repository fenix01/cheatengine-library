unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Connector, Vcl.ExtCtrls;

type
  TfmSample = class(TForm)
    Panel2: TPanel;
    ltProcess: TListBox;
    btnProcesses: TButton;
    btnOpenProcess: TButton;
    memoScript: TMemo;
    GroupBox1: TGroupBox;
    btnLoad: TButton;
    btnUnload: TButton;
    btnInject: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
    procedure btnProcessesClick(Sender: TObject);
    procedure btnOpenProcessClick(Sender: TObject);
    procedure btnInjectClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  fmSample: TfmSample;
  dllHandle: THandle;

implementation

{$R *.dfm}

procedure TfmSample.btnLoadClick(Sender: TObject);
begin
  {$ifdef Win64}
  dllHandle := LoadLibrary('ce-lib64.dll');
  {$ENDIF}
  {$ifdef Win32}
  dllHandle := LoadLibrary('ce-lib32.dll');
  {$ENDIF}
  if dllHandle <> 0 then
  begin
    ShowMessage('loaded');
    loadFunctions(dllHandle);
  end
  else
    ShowMessage(IntToStr(GetLastError()));
end;

procedure TfmSample.btnUnloadClick(Sender: TObject);
begin
  FreeLibrary(Handle);
end;

procedure TfmSample.btnInjectClick(Sender: TObject);
begin
  IAddScript('test',memoScript.Text);
  IActivateRecord(0,true);
end;

procedure TfmSample.btnOpenProcessClick(Sender: TObject);
var
pid : String;
begin
 pid := ltProcess.Items.Strings[ltProcess.ItemIndex];
 pid := Copy(pid,0,8);
 if pid <> '' then
  IOpenProcess(pid);
end;

procedure TfmSample.btnProcessesClick(Sender: TObject);
var
  s1 : WideString;
  s2 : String;
begin
  IGetProcessList(s1);
  s2 := s1;
  ltProcess.Items.Text := s2;
end;

end.
