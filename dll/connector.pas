unit connector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, symbolhandler, CEFuncProc, windows, PEInfounit,
  MemoryRecordDatabase, MemoryRecordUnit, Dialogs;

//procedure ILoadCommonModuleList; stdcall;
procedure IGetProcessList(out processes : WideString);stdcall;
//procedure IGetModuleList(withSystemModules: boolean ; out modules : WideString);stdcall;
procedure IOpenProcess(pid : WideString);stdcall;
procedure IResetScripts();stdcall;
procedure IAddScript(name : WideString; script : WideString);stdcall;
procedure IRemoveScript(id : integer); stdcall;
procedure IActivateScript(id : integer; activate : boolean);stdcall;


var
  recordTable : TMemoryRecordTable;

implementation

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

procedure PWOP(ProcessIDString:string);
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

procedure ILoadCommonModuleList; stdcall;
begin
     symhandler.loadCommonModuleList;
end;

procedure IGetModuleList(withSystemModules: boolean ; out modules : WideString);stdcall;
var
  _modules : TStringList;
begin
  try
    _modules := TStringList.Create;
    GetModuleList(_modules,withSystemModules);
    modules := _modules.Text;
  finally
    _modules.Free;
  end;
end;

procedure IGetProcessList(out processes : WideString);stdcall;
var
  process : TStringList;
begin
  try
     process := TStringList.Create();
     GetProcessList(process);
     processes := process.Text;
  finally
     process.Free;
  end;
end;

procedure IOpenProcess(pid : WideString);stdcall;
begin
     IResetScripts();
     PWOP(pid);
     openProcessEpilogue();
     symhandler.reinitialize();
     symhandler.waitforsymbolsloaded;
     symhandler.loadmodulelist;
end;

procedure IResetScripts();stdcall;
begin
  if recordTable <> nil then
  begin
    recordTable.Free;
    recordTable := nil;
  end;
  recordTable := TMemoryRecordTable.Create();
end;

procedure IAddScript(name : WideString; script : WideString); stdcall;
var
  memrec : TMemoryRecord;
begin
  if recordTable <> nil then
  begin
    recordTable.addAutoAssembleScript(name,script);
  end;
end;

procedure IRemoveScript(id : integer); stdcall;
var
  memrec : TMemoryRecord;
begin
  if recordTable <> nil then
  begin
    recordTable.RemoveRecord(id);
  end;
end;

procedure IActivateScript(id : integer; activate : boolean);stdcall;
var
  memrec : TMemoryRecord;
begin
  memrec := recordTable.getRecordWithID(id);
  memrec.Active:=true;
  if activate then
     recordTable.ActivateSelected(ftFrozen)
  else
     recordTable.DeactivateSelected;
end;

end.

