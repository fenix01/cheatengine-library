unit connector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, symbolhandler, CEFuncProc, windows, PEInfounit,
  MemoryRecordDatabase, MemoryRecordUnit, Dialogs, AddressChangeUnit,
  memscan,scanner, CustomTypeHandler;

//procedure ILoadCommonModuleList; stdcall;
procedure IGetProcessList(out processes : WideString);stdcall;
//procedure IGetModuleList(withSystemModules: boolean ; out modules : WideString);stdcall;
procedure IOpenProcess(pid : WideString);stdcall;

//control the virtual cheat table
procedure IResetScripts();stdcall;
procedure IAddScript(name : WideString; script : WideString);stdcall;
procedure IRemoveScript(id : integer); stdcall;
procedure IActivateScript(id : integer; activate : boolean);stdcall;

//control an address from the virtual cheat table
procedure IAddAddressManually(initialaddress: WideString=''; vartype: TVariableType=vtDword);stdcall;
procedure IGetValue(id : integer ; out value : WideString);stdcall;

//control the memory scanner
procedure IInitMemoryScanner(); stdcall;
procedure IDeinitMemoryScanner(); stdcall;

procedure IFirstScan(scanOption: TScanOption; VariableType: TVariableType;
  roundingtype: TRoundingType; scanvalue1, scanvalue2: WideString; startaddress,stopaddress: WideString;
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive: boolean; fastscanmethod: TFastScanMethod=fsmNotAligned;
  fastscanparameter: WideString=''); stdcall;

procedure INextScan(scanOption: TScanOption; roundingtype: TRoundingType;
  scanvalue1, scanvalue2: string;
  hexadecimal,binaryStringAsDecimal, unicode, casesensitive,percentage,compareToSavedScan: boolean;
  savedscanname: string); stdcall; //next scan, determine what kind of scan and give to firstnextscan/nextnextscan

function ICountAddressesFound():uint64; stdcall;
procedure IRegisterScanDoneCallback(fun : TOnScanDoneCallback);stdcall;
procedure IInitializeFoundList();stdcall;
procedure IGetAddress(i: qword;out address: WideString; out value: WideString)stdcall;

var
  recordTable : TMemoryRecordTable;
  scanner_ : TScanner;

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

procedure IAddAddressManually(initialaddress: WideString=''; vartype: TVariableType=vtDword);stdcall;
var
  memrec : TMemoryRecord;
begin
  if recordTable <> nil then
    begin
      recordTable.addAddressManually(initialaddress,vartype);
    end;
end;

procedure IGetValue(id : integer ; out value : WideString);stdcall;
var
  memrec : TMemoryRecord;
begin
    memrec := recordTable.getRecordWithID(id);
    value := memrec.GetValue;
end;

procedure IInitMemoryScanner(); stdcall;
begin
  if (assigned(scanner_)) then IDeinitMemoryScanner();
  scanner_ := TScanner.Create();
  scanner_.addScanner();
end;

procedure IDeinitMemoryScanner(); stdcall;
begin
  scanner_.state^.foundlist.Free;
  scanner_.state^.memscan.Free;
  scanner_.Free;
  scanner_ := nil;
end;

procedure IFirstScan(scanOption: TScanOption; VariableType: TVariableType;
  roundingtype: TRoundingType; scanvalue1, scanvalue2: WideString; startaddress,stopaddress: WideString;
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive: boolean; fastscanmethod: TFastScanMethod=fsmNotAligned;
  fastscanparameter: WideString=''); stdcall;
var
  scanstart,scanend : PtrUint;
begin
  scanstart := StrToQWordEx(startaddress);
  scanend := StrToQWordEx(stopaddress);
  scanner_.state^.memscan.firstscan(scanOption,VariableType,roundingtype,scanvalue1,
  scanvalue2,scanstart,scanend,hexadecimal,binaryStringAsDecimal,
  unicode,casesensitive,fastscanmethod,fastscanparameter);
end;

procedure INextScan(scanOption: TScanOption; roundingtype: TRoundingType;
  scanvalue1, scanvalue2: string;
  hexadecimal,binaryStringAsDecimal, unicode, casesensitive,percentage,compareToSavedScan: boolean;
  savedscanname: string); stdcall;
begin
  scanner_.state^.memscan.NextScan(scanOption,roundingtype,scanvalue1,scanvalue2,hexadecimal,
  binaryStringAsDecimal,unicode,casesensitive,percentage,compareToSavedScan,savedscanname);
end;

function ICountAddressesFound():uint64; stdcall;
begin
  if assigned(scanner_) and assigned(scanner_.state^.foundlist) then
    result := scanner_.state^.foundlist.count
  else result := -1;
end;

procedure IRegisterScanDoneCallback(fun : TOnScanDoneCallback);stdcall;
begin
  if assigned(scanner_) then
    scanner_.scandone := fun;
end;

procedure IInitializeFoundList();stdcall;
begin
  if assigned(scanner_) then
    scanner_.state^.foundlist.Initialize();
end;

procedure IGetAddress(i: qword;out address: WideString; out value: WideString)stdcall;
var
  address_ : PtrUint;
  value_ : string;
  extra : dword;
begin
  if assigned(scanner_) then
  begin
    address_ := scanner_.state^.foundlist.GetAddress(i,extra,value_);
    address := IntToHex(address_,8);
    value := value_;
  end
  else begin
    address := 'null';
    value := 'null';
  end;

end;

end.

