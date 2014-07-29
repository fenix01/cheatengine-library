unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Connector, Vcl.ExtCtrls,
  Vcl.ComCtrls, Math;

const
  wm_scandone = WM_APP + 2;

type
  TfmScanner = class(TForm)
    Panel2: TPanel;
    ltProcess: TListBox;
    btnProcesses: TButton;
    btnOpenProcess: TButton;
    GroupBox1: TGroupBox;
    btnLoad: TButton;
    btnUnload: TButton;
    btnFirstScan: TButton;
    btnNextScan: TButton;
    cbScanType: TComboBox;
    edtValue1: TEdit;
    edtValue2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbValueType: TComboBox;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    edtStartScan: TEdit;
    edtEndScan: TEdit;
    lvScanner: TListView;
    GroupBox3: TGroupBox;
    chkUnicode: TCheckBox;
    chkCase: TCheckBox;
    Timer1: TTimer;
    btnNewScan: TButton;
    cbFastScan: TCheckBox;
    rbAlignment: TRadioButton;
    rbLastDigits: TRadioButton;
    edtAlignment: TEdit;
    cbWritable: TCheckBox;
    cbExecutable: TCheckBox;
    cbCopyOnWrite: TCheckBox;
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
    procedure btnProcessesClick(Sender: TObject);
    procedure btnOpenProcessClick(Sender: TObject);
    procedure btnFirstScanClick(Sender: TObject);
    procedure btnNextScanClick(Sender: TObject);
    procedure cbScanTypeChange(Sender: TObject);
    procedure cbValueTypeChange(Sender: TObject);
    procedure edtStartScanChange(Sender: TObject);
    procedure edtEndScanChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lvScannerData(Sender: TObject; Item: TListItem);
    procedure btnNewScanClick(Sender: TObject);
    procedure cbFastScanClick(Sender: TObject);
    procedure chkUnicodeClick(Sender: TObject);
    procedure chkCaseClick(Sender: TObject);
  private
    scanopt: TScanOption;
    varopt: TVariableType;
    unicode: boolean;
    casesensitive: boolean;
    startscan: string;
    endscan: string;
    max: integer;
    procedure WScanDone(var message: TMessage); message wm_scandone;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  fmScanner: TfmScanner;
  dllHandle: THandle;

implementation

{$R *.dfm}

procedure TfmScanner.btnLoadClick(Sender: TObject);
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
    ShowMessage('Error while loading the library :' +IntToStr(GetLastError()));
end;

procedure TfmScanner.btnUnloadClick(Sender: TObject);
begin
  FreeLibrary(Handle);
end;

procedure TfmScanner.cbScanTypeChange(Sender: TObject);
begin
  case cbScanType.ItemIndex of
    0:
      scanopt := soUnknownValue;
    1:
      scanopt := soExactValue;
    2:
      scanopt := soValueBetween;
    3:
      scanopt := soBiggerThan;
    4:
      scanopt := soSmallerThan;
    5:
      scanopt := soIncreasedValue;
    6:
      scanopt := soIncreasedValueBy;
    7:
      scanopt := soDecreasedValue;
    8:
      scanopt := soIncreasedValueBy;
    9:
      scanopt := soChanged;
    10:
      scanopt := soUnchanged;
  end;
end;

procedure TfmScanner.cbValueTypeChange(Sender: TObject);
begin
  case cbValueType.ItemIndex of
    0:
      varopt := vtBinary;
    1:
      varopt := vtByte;
    2:
      varopt := vtWord;
    3:
      varopt := vtDword;
    4:
      varopt := vtQword;
    5:
      varopt := vtSingle;
    6:
      varopt := vtDouble;
    7:
      varopt := vtString;
  end;
  case varopt of
    vtBinary, vtByte, vtString, vtUnicodeString, vtByteArrays:
      edtAlignment.Text := '1'; // byte, aob, string
    vtWord:
      edtAlignment.Text := '2'; // word
  else
    edtAlignment.Text := '4'; // dword, float, single, etc...
  end;
end;

procedure TfmScanner.chkCaseClick(Sender: TObject);
begin
  casesensitive := chkCase.Checked;
end;

procedure TfmScanner.chkUnicodeClick(Sender: TObject);
begin
  unicode := chkUnicode.Checked;
end;

procedure TfmScanner.cbFastScanClick(Sender: TObject);
begin
  edtAlignment.Enabled := cbFastScan.Checked and cbFastScan.Enabled;
  rbAlignment.Enabled := edtAlignment.Enabled;
  rbLastDigits.Enabled := edtAlignment.Enabled;
end;

procedure TfmScanner.edtEndScanChange(Sender: TObject);
begin
  endscan := '$' + edtEndScan.Text;
end;

procedure TfmScanner.edtStartScanChange(Sender: TObject);
begin
  startscan := '$' + edtStartScan.Text;
end;

procedure TfmScanner.lvScannerData(Sender: TObject; Item: TListItem);
var
  a, v: WideString;
begin
  try
    IGetAddress(Item.Index, a, v);
    Item.Caption := a;
    Item.subitems.add(v);
  except
    on e: exception do
    begin
      Item.Caption := 'CE Error:' + IntToStr(Item.Index);
      Item.subitems.add(e.message);
      Item.subitems.add('');
    end;
  end;
end;

procedure TfmScanner.Timer1Timer(Sender: TObject);
begin
  IResetValues();
end;

procedure TfmScanner.WScanDone(var message: TMessage);
var
  i, size: integer;
begin
  lvScanner.items.count := 0;
  lvScanner.ItemIndex := -1;
  lvScanner.Clear;
  btnNextScan.Enabled := true;
  size := IGetBinarySize;
  IInitFoundList(varopt, size, false, false, false, unicode);

  if (scanopt <> TScanOption.soUnknownValue) then
  begin
    i := min(ICountAddressesFound(), 10000000);
    lvScanner.items.count := i;

    while lvScanner.items.count = 0 do
    begin
      i := i div 10;
      lvScanner.items.count := i;
      if i = 0 then
        break;
    end;
  end;

  ShowMessage(IntToStr(ICountAddressesFound()));
  Timer1.Enabled := true;
end;

procedure TfmScanner.btnFirstScanClick(Sender: TObject);
var
  fastscanmethod: TFastScanMethod;
  writable, executable, copyOnWrite: Tscanregionpreference;
begin
  Timer1.Enabled := false;
  btnFirstScan.Enabled := false;

  case cbWritable.State of
    cbUnchecked:
      writable := scanExclude;
    cbChecked:
      writable := scanInclude;
    cbGrayed:
      writable := scanDontCare;
  end;

  case cbExecutable.State of
    cbUnchecked:
      executable := scanExclude;
    cbChecked:
      executable := scanInclude;
    cbGrayed:
      executable := scanDontCare;
  end;

  case cbCopyOnWrite.State of
    cbUnchecked:
      copyOnWrite := scanExclude;
    cbChecked:
      copyOnWrite := scanInclude;
    cbGrayed:
      copyOnWrite := scanDontCare;
  end;
  IConfigScanner(writable,executable,copyOnWrite);

  if cbFastScan.Checked then
  begin
    if rbAlignment.Checked then
      fastscanmethod := fsmAligned
    else
      fastscanmethod := fsmLastDigits;
  end
  else
    fastscanmethod := fsmNotAligned;

  IFirstScan(scanopt, varopt, TRoundingType.rtRounded, edtValue1.Text,
    edtValue2.Text, startscan, endscan, false, false, unicode, casesensitive,
    fastscanmethod, edtAlignment.Text);
end;

procedure TfmScanner.btnNewScanClick(Sender: TObject);
begin
  INewScan();
  btnNextScan.Enabled := false;
  btnFirstScan.Enabled := true;
  edtValue1.Text := '';
  edtValue2.Text := '';
  lvScanner.items.count := 0;
  lvScanner.ItemIndex := -1;
  lvScanner.Clear;
end;

procedure TfmScanner.btnNextScanClick(Sender: TObject);
begin
  Timer1.Enabled := false;
  btnNextScan.Enabled := false;
  INextScan(scanopt, TRoundingType.rtRounded, edtValue1.Text, edtValue2.Text,
    false, false, unicode, casesensitive, false, false, '');
end;

procedure TfmScanner.btnOpenProcessClick(Sender: TObject);
var
  pid: String;
begin
  pid := ltProcess.items.Strings[ltProcess.ItemIndex];
  pid := Copy(pid, 0, 8);
  if pid <> '' then
  begin
    IOpenProcess(pid);
    IInitMemoryScanner(fmScanner.Handle);
    showmessage('process opened');
    scanopt := TScanOption.soExactValue;
    varopt := TVariableType.vtDword;
    startscan := '$0000000000000000';
    endscan := '$7fffffffffffffff';
    unicode := false;
    casesensitive := false;
    btnNewScan.Enabled := true;
    btnFirstScan.Enabled := true;
  end;
end;

procedure TfmScanner.btnProcessesClick(Sender: TObject);
var
  s1: WideString;
  s2: String;
begin
  IGetProcessList(s1);
  s2 := s1;
  ltProcess.items.Text := s2;
end;

end.
