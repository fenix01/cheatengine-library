unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, CEFuncProc, windows, autoassembler, symbolhandler,
  PEInfounit, StrUtils, MemoryRecordUnit,MemoryRecordDatabase, PEInfoFunctions;

type

  { TfmCE }

  TfmCE = class(TForm)
    btnAddScript: TButton;
    btnProcess: TButton;
    chkScripts: TCheckGroup;
    edtName: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblNom: TLabel;
    Label3: TLabel;
    lblPID: TLabel;
    ltProcess: TListBox;
    memoScript: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlControl: TPanel;
    procedure btnAddScriptClick(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure chkScriptsItemClick(Sender: TObject; Index: integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ltProcessClick(Sender: TObject);
  private
    recordTable : TMemoryRecordTable;
    procedure resetScripts();
    { private declarations }
  public
    procedure PWOP(ProcessIDString:string);
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


procedure openProcessEpilogue();
var
  i, j: integer;
  fname, expectedfilename: string;

  wasActive: boolean;
begin
     symhandler.reinitialize;
    setcodeanddatabase;
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

procedure TfmCE.btnProcessClick(Sender: TObject);
begin
  GetProcessList(ltProcess,false);
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

end.

