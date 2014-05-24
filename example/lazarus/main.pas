unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, LResources, CEFuncProc, windows, autoassembler,
  symbolhandler, PEInfounit, StrUtils, MemoryRecordUnit, MemoryRecordDatabase,
  PEInfoFunctions, memscan, foundlisthelper, byteinterpreter;

const
  wm_scandone = WM_USER + 2;
  foundlistDisplayOverride = 0;

type
  TScanState = record
    alignsizechangedbyuser: boolean;
    compareToSavedScan: boolean;
    currentlySelectedSavedResultname: string; //I love long variable names

    lblcompareToSavedScan: record
      Caption: string;
      Visible: boolean;
      left: integer;
    end;


    FromAddress: record
      Text: string;
    end;

    ToAddress: record
      Text: string;
    end;

    cbReadOnly: record
      Checked: boolean;
    end;

    cbfastscan: record
      Checked: boolean;
    end;

    cbunicode: record
      checked: boolean;
      visible: boolean;
    end;

    cbCaseSensitive: record
      checked: boolean;
      visible: boolean;
    end;

    edtAlignment: record
      Text: string;
    end;


    cbpercentage: record
      exists: boolean;
      Checked: boolean;
    end;


    floatpanel: record
      Visible: boolean;
      rounded: boolean;
      roundedextreme: boolean;
      truncated: boolean;
    end;

    rbbit: record
      Visible: boolean;
      Enabled: boolean;
      Checked: boolean;
    end;

    rbdec: record
      Visible: boolean;
      Enabled: boolean;
      Checked: boolean;
    end;

    cbHexadecimal: record
      Visible: boolean;
      Checked: boolean;
      Enabled: boolean;
    end;

    gbScanOptionsEnabled: boolean;

    scantype: record
      options: string;
      ItemIndex: integer;
      Enabled: boolean;
      dropdowncount: integer;
    end;

    vartype: record
      //options: TStringList;
      ItemIndex: integer;
      Enabled: boolean;
    end;


    memscan: TMemscan;
    foundlist: TFoundList;


    scanvalue: record
      Visible: boolean;
      Text: string;
    end;

    scanvalue2: record
      exists: boolean;
      Text: string;
    end;

    firstscanstate: record
      Caption: string;
      Enabled: boolean;
    end;

    nextscanstate: record
      Enabled: boolean;
    end;

    button2: record
      tag: integer;
    end;

    foundlist3: record
      ItemIndex: integer;
    end;
    foundlistDisplayOverride: integer;

  end;
  PScanState = ^TScanState;

type

  { TfmCE }

  TfmCE = class(TForm)
    btnAddScript: TButton;
    btnNextScan: TButton;
    btnProcess: TButton;
    btnFirstScan: TButton;
    cbScanType: TComboBox;
    chkScripts: TCheckGroup;
    cbValueType: TComboBox;
    edtValue: TEdit;
    edtName: TEdit;
    edtValue1: TEdit;
    gbScanner: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblNom: TLabel;
    Label3: TLabel;
    lblPID: TLabel;
    ListView1: TListView;
    ltProcess: TListBox;
    memoScript: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlControl: TPanel;
    Timer1: TTimer;
    procedure btnAddScriptClick(Sender: TObject);
    procedure btnNextScanClick(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure btnFirstScanClick(Sender: TObject);
    procedure cbScanTypeChange(Sender: TObject);
    procedure cbValueTypeChange(Sender: TObject);
    procedure chkScriptsItemClick(Sender: TObject; Index: integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure gbScannerClick(Sender: TObject);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure ListView1Data(Sender: TObject; Item: TListItem);
    procedure ltProcessClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    scanopt : TScanOption;
    varopt : TVariableType;
    recordTable : TMemoryRecordTable;
    foundlist : TFoundList;
    memscan : Tmemscan;
    procedure resetScripts();
    { private declarations }
  public
    procedure PWOP(ProcessIDString:string);
    procedure openProcessEpilogue();
    procedure addScanner();
    procedure SetupInitialScanTabState(scanstate: PScanState; IsFirstEntry: boolean);
    procedure ScanDone(var message: TMessage); message WM_SCANDONE;
    { public declarations }
  end;

var
  fmCE: TfmCE;
implementation

procedure AdjustPrivilege();
var
  pid: dword;
  tokenhandle: thandle;
  tp: TTokenPrivileges;
  prev: TTokenPrivileges;
  ReturnLength: Dword;
  minworkingsize, maxworkingsize: LongWord;
begin
     pid := GetCurrentProcessID;
  ownprocesshandle := OpenProcess(PROCESS_ALL_ACCESS, True, pid);
  tokenhandle := 0;

  if ownprocesshandle <> 0 then
  begin
    if OpenProcessToken(ownprocesshandle, TOKEN_QUERY or TOKEN_ADJUST_PRIVILEGES,
      tokenhandle) then
    begin
      ZeroMemory(@tp, sizeof(tp));

      if lookupPrivilegeValue(nil, 'SeDebugPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          ShowMessage('Failure setting the debug privilege. Debugging may be limited.');
      end;


      ZeroMemory(@tp, sizeof(tp));
      if lookupPrivilegeValue(nil, SE_LOAD_DRIVER_NAME, tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          ShowMessage('Failure setting the load driver privilege. Debugging may be limited.');
      end;




      if GetSystemType >= 7 then
      begin
        ZeroMemory(@tp, sizeof(tp));
        if lookupPrivilegeValue(nil, 'SeCreateGlobalPrivilege',
          tp.Privileges[0].Luid) then
        begin
          tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
          tp.PrivilegeCount := 1; // One privilege to set
          if not AdjustTokenPrivileges(tokenhandle, False, tp,
            sizeof(tp), prev, returnlength) then
            ShowMessage('Failure setting the CreateGlobal privilege.');
        end;



        {$ifdef cpu64}
        ZeroMemory(@tp, sizeof(tp));
        ZeroMemory(@prev, sizeof(prev));
        if lookupPrivilegeValue(nil, 'SeLockMemoryPrivilege', tp.Privileges[0].Luid) then
        begin
          tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
          tp.PrivilegeCount := 1; // One privilege to set
          AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
        end;

        {$endif}
      end;


      ZeroMemory(@tp, sizeof(tp));
      ZeroMemory(@prev, sizeof(prev));
      if lookupPrivilegeValue(nil, 'SeIncreaseWorkingSetPrivilege',
        tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
      end;

    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeSecurityPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;


    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeTakeOwnershipPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeManageVolumePrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeBackupPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeCreatePagefilePrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeRestorePrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;


    if GetProcessWorkingSetSize(ownprocesshandle, minworkingsize, maxworkingsize) then
      SetProcessWorkingSetSize(ownprocesshandle, 16 * 1024 * 1024, 64 * 1024 * 1024);

  end;
end;

procedure GetEntryPointAndDataBase(var code: ptrUint; var data: ptrUint);
var modulelist: tstringlist;
    base: ptrUint;
    header: pointer;
    headersize: dword;
    br: dword;
begin
  code:=$00400000;
  data:=$00400000; //on failure

  modulelist:=tstringlist.Create;
  symhandler.getModuleList(modulelist);
  outputdebugstring('Retrieved the module list');

  if modulelist.Count>0 then
  begin
    base:=ptrUint(modulelist.Objects[0]);


    getmem(header,4096);
    try
      if readprocessmemory(processhandle,pointer(base),header,4096,br) then
      begin
        headersize:=peinfo_getheadersize(header);

        if headersize>0 then
        begin
          if headersize>1024*512 then exit;

          freemem(header);
          getmem(header,headersize);
          if not readprocessmemory(processhandle,pointer(base),header,headersize,br) then exit;

          Outputdebugstring('calling peinfo_getEntryPoint');
          code:=base+peinfo_getEntryPoint(header, headersize);

          OutputDebugString('calling peinfo_getdatabase');
          data:=base+peinfo_getdatabase(header, headersize);
        end;


      end;
    finally
      freemem(header);
    end;
  end;
  modulelist.free;
end;

procedure setcodeanddatabase;
var code,data: ptrUint;
begin
  if processid=$ffffffff then  //file instead of process
  begin
    code:=0;
    data:=0;
  end
  else
    GetEntryPointAndDataBase(code,data);
end;


procedure TfmCE.openProcessEpilogue();
var
  i, j: integer;
  fname, expectedfilename: string;

  wasActive: boolean;
begin
     symhandler.reinitialize;
     setcodeanddatabase;
     //foundlist.Clear;
end;

{$R *.lfm}

{ TfmCE }

procedure TfmCE.PWOP(ProcessIDString:string);
var i:integer;
begin
  val('$'+ProcessIDString,ProcessHandler.processid,i);
  if i<>0 then raise exception.Create('%s isn''t a valid processID');
  if Processhandle<>0 then
  begin
    CloseHandle(ProcessHandle);
    ProcessHandler.ProcessHandle:=0;
  end;
  Open_Process;
  ProcessSelected:=true;
end;


procedure TfmCE.btnAddScriptClick(Sender: TObject);
var
  memrec : TMemoryRecord;
begin
  if recordTable = nil then
  begin
    showmessage('You have to opened a process first !');
  end
  else
  begin
    recordTable.addAutoAssembleScript(edtName.Caption,memoScript.Lines.Text);
    chkScripts.Items.Add(edtName.Caption);
  end;

end;

procedure TfmCE.btnNextScanClick(Sender: TObject);
begin
  foundlist.Deinitialize;
  memscan.nextscan(scanopt, rtRounded, utf8toansi(edtValue.Text),
    utf8toansi(edtValue1.Text), false, false,
    false, false, false, false,
    '');
end;

procedure TfmCE.btnProcessClick(Sender: TObject);
begin
  GetProcessList(ltProcess,false);
end;

procedure TfmCE.btnFirstScanClick(Sender: TObject);
var
  scanstart,scanend : PtrUint;
  fastscanmethod : Tfastscanmethod;

begin
  memscan := Tmemscan.create(nil);
  foundlist := TFoundList.create(ListView1,memscan);
  addScanner();
  memscan.setScanDoneCallback(fmCE.handle, wm_scandone);
  fastscanmethod:=TFastScanMethod.fsmAligned;

  memscan.scanWritable := scanInclude;
  memscan.scanExecutable := scanExclude;
  memscan.scanCopyOnWrite := scanExclude;
  scanstart := StrToQWordEx('$' + '0000000000000000');
  scanend := StrToQWordEx('$' + '7fffffffffffffff');
  memscan.firstscan(scanopt,varopt,TRoundingType.rtRounded,
  utf8toansi(edtValue.Text), utf8toansi(''),scanstart,scanend,
  false,false,false,true,fastscanmethod,'4',nil);
end;

procedure TfmCE.cbScanTypeChange(Sender: TObject);
begin
  case cbScanType.ItemIndex of
    0 : scanopt:= soUnknownValue;
    1 : scanopt:=soExactValue;
    2 : scanopt:=soValueBetween;
    3 : scanopt:=soBiggerThan;
    4 : scanopt:=soSmallerThan;
    5 : scanopt:=soIncreasedValue;
    6 : scanopt:=soIncreasedValueBy;
    7 : scanopt:=soDecreasedValue;
    8 : scanopt:=soIncreasedValueBy;
    9 : scanopt:=soChanged;
    10 : scanopt:=soUnchanged;
  end;
end;

procedure TfmCE.cbValueTypeChange(Sender: TObject);
begin
  case cbValueType.ItemIndex of
    0 : varopt:= vtBinary;
    1 : varopt:=vtByte;
    2 : varopt:=vtWord;
    3 : varopt:=vtDword;
    4 : varopt:=vtQword;
    5 : varopt:=vtSingle;
    6 : varopt:=vtDouble;
    7 : varopt:=vtString;
  end;
end;

procedure TfmCE.chkScriptsItemClick(Sender: TObject; Index: integer);
var
  memrec : TMemoryRecord;
begin
  memrec := recordTable.getRecordWithID(Index);
  edtName.Caption:= memrec.Description;
  memoScript.Lines := memrec.AutoAssemblerData.script;
  if chkScripts.Checked[Index] then
  begin
    memrec.Active:=true;
    recordTable.ActivateSelected(ftFrozen);
  end
  else
  begin
    memrec.Active:=false;
    recordTable.DeactivateSelected;
  end;
end;

procedure TfmCE.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  recordTable.Free;
end;

procedure TfmCE.FormCreate(Sender: TObject);
begin
     AdjustPrivilege();
     symhandlerInitialize;
     symhandler.loadCommonModuleList;
end;

procedure TfmCE.gbScannerClick(Sender: TObject);
begin

end;

procedure TfmCE.ListView1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin

end;

procedure TfmCE.ListView1Data(Sender: TObject; Item: TListItem);
var
  extra: dword;
  Value, PreviousValue: string;
  Address: ptruint;
  addressString: string;
  valuetype: TVariableType;

  ssVt: TVariableType;
  p: pointer;
  invalid: boolean;
begin
  try
    valuetype:=foundlist.vartype;
    address := foundlist.GetAddress(item.Index, extra, Value);
    AddressString:=IntToHex(address,8);
    Value := AnsiToUtf8(Value);

    if foundlistDisplayOverride<>0 then
    begin
      case foundlistDisplayOverride of
        1: valuetype:=vtByte;
        2: valuetype:=vtWord;
        3: valuetype:=vtDword;
        4: valuetype:=vtQword;
        5: valuetype:=vtSingle;
        6: valuetype:=vtDouble;
      end;

      value:=readAndParseAddress(address, valuetype, nil);
    end;


    PreviousValue:='';


    if foundlist.vartype = vtBinary then //binary
    begin
      AddressString := AddressString + '^' + IntToStr(extra);
    end;
    item.Caption := AddressString;
    item.subitems.add(Value);

  except
    on e: exception do
    begin
    //ShowMessage(IntToStr(item.index));
      item.Caption := 'CE Error:'+inttostr(item.index);
      item.subitems.add(e.Message);
      item.subitems.add('');
    end;
  end;
end;



procedure TfmCE.resetScripts();
begin
  if recordTable <> nil then
  begin
    recordTable.Free;
    chkScripts.Items.Clear;
    edtName.Caption:= 'Name';
    memoScript.Clear;
    recordTable := TMemoryRecordTable.Create();
  end
  else
    recordTable := TMemoryRecordTable.Create();
end;

procedure TfmCE.ltProcessClick(Sender: TObject);
var ProcessIDString: String;
    ProcessName : String;
begin
  resetScripts();
  ProcessIDString:=copy(ltProcess.Items[ltProcess.ItemIndex], 1, pos('-',ltProcess.Items[ltProcess.ItemIndex])-1);
  ProcessName := copy(ltProcess.Items[ltProcess.ItemIndex], pos('-',ltProcess.Items[ltProcess.ItemIndex])+1, Length(ltProcess.Items[ltProcess.ItemIndex]));
  PWOP(ProcessIDString);
  openProcessEpilogue();
  symhandler.reinitialize();
  symhandler.waitforsymbolsloaded;
  symhandler.loadmodulelist;
  lblNom.Caption:=ProcessName;
  lblPID.Caption:=ProcessIDString;
  showmessage('process succesfully opened');
end;

procedure TfmCE.Timer1Timer(Sender: TObject);
begin
    if foundlist <> nil then
    begin
         foundlist.RefetchValueList;
         ListView1.Refresh;
  end;
end;

procedure TfmCE.ScanDone(var message: TMessage);
begin
  foundlist.Initialize(vtDword, memscan.Getbinarysize, false,
    false, false, false,nil);
  showmessage(IntToStr(memscan.GetFoundCount));
    Timer1.Enabled:=true;
end;

procedure TfmCE.addScanner();
var
   newstate: PScanState;
begin
   getmem(newstate, sizeof(TScanState));
   SetupInitialScanTabState(newstate, True);
end;

procedure TfmCE.SetupInitialScanTabState(scanstate: PScanState;
  IsFirstEntry: boolean);
begin
  ZeroMemory(scanstate, sizeof(TScanState));

  if IsFirstEntry then
  begin
    scanstate^.memscan := memscan;
    scanstate^.foundlist := foundlist;
  end
  else
  begin
    scanstate^.memscan := tmemscan.Create(nil);
    scanstate^.foundlist := TFoundList.Create(ListView1, scanstate^.memscan);    //build again
    scanstate^.memscan.setScanDoneCallback(fmCE.handle, wm_scandone);
  end;

  //initial scans don't have a previous scan
  scanstate^.lblcompareToSavedScan.Visible := False;
  scanstate^.compareToSavedScan := False;

end;

end.

