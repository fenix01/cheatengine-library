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
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
    procedure btnProcessesClick(Sender: TObject);
    procedure btnOpenProcessClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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

procedure OnScanDone;
var
a,v : WideString;
begin
  IInitializeFoundList();
  ShowMessage(inttostr(ICountAddressesFound()));
  IGetAddress(0,a,v);
  showmessage(a+':'+v);
end;

procedure TfmSample.btnLoadClick(Sender: TObject);
begin
  dllHandle := LoadLibrary
    ('ce-lib64.dll');
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

procedure TfmSample.Button1Click(Sender: TObject);
begin
  IAddScript('test',memoScript.Text);
  IActivateScript(0,true);
end;

procedure TfmSample.Button2Click(Sender: TObject);
begin
  IInitMemoryScanner();
  IRegisterScanDoneCallback(OnScanDone);
  IFirstScan(soExactValue,vtDword,TRoundingType.rtRounded,
  utf8toansi('516'), utf8toansi(''),'$0000000000000000','$7fffffffffffffff',
  false,false,false,true,TFastScanMethod.fsmAligned,'4');
end;

procedure TfmSample.Button3Click(Sender: TObject);
begin
  showmessage(inttostr(ICountAddressesFound()));
  IDeinitMemoryScanner();
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
