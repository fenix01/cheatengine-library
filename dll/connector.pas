unit connector;

{$MODE Delphi}

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
procedure IResetTable();stdcall;
procedure IAddScript(name : WideString; script : WideString);stdcall;
procedure IRemoveRecord(id : integer); stdcall;
procedure IActivateRecord(id : integer; activate : boolean);stdcall;
procedure IApplyFreeze();stdcall;

//control an address from the virtual cheat table
procedure IAddAddressManually(initialaddress: WideString=''; vartype: TVariableType=vtDword);stdcall;
procedure IGetValue(id : integer ; out value : WideString);stdcall;
procedure ISetValue(id : integer ; value : WideString ; freezer : boolean);stdcall;

//control the memory scanner
procedure IInitMemoryScanner(hwnd : THandle); stdcall;
procedure INewScan();stdcall;
procedure IConfigScanner(scanWritable: Tscanregionpreference;scanExecutable: Tscanregionpreference;scanCopyOnWrite: Tscanregionpreference);stdcall;
procedure IFirstScan(scanOption: TScanOption; VariableType: TVariableType;
  roundingtype: TRoundingType; scanvalue1, scanvalue2: WideString; startaddress,stopaddress: WideString;
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive: boolean; fastscanmethod: TFastScanMethod=fsmNotAligned;
  fastscanparameter: WideString=''); stdcall;

procedure INextScan(scanOption: TScanOption; roundingtype: TRoundingType;
  scanvalue1, scanvalue2: WideString;
  hexadecimal,binaryStringAsDecimal, unicode, casesensitive,percentage,compareToSavedScan: boolean;
  savedscanname: WideString); stdcall; //next scan, determine what kind of scan and give to firstnextscan/nextnextscan

function ICountAddressesFound():uint64; stdcall;
procedure IGetAddress(i: qword;out address: WideString; out value: WideString)stdcall;
procedure IInitFoundList(vartype: TVariableType; varlength: integer; hexadecimal,
  signed,binaryasdecimal,unicode: boolean);stdcall;
procedure IResetValues;stdcall;
procedure IRebaseAddressList(index : integer);stdcall;
function IGetBinarySize():integer;stdcall;

var
  recordTable : TMemoryRecordTable;
  scanner_ : TIScanner;

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
     IResetTable();
     PWOP(pid);
     openProcessEpilogue();
     symhandler.reinitialize();
     symhandler.waitforsymbolsloaded;
     symhandler.loadmodulelist;
end;

procedure IResetTable();stdcall;
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

procedure IRemoveRecord(id : integer); stdcall;
var
  memrec : TMemoryRecord;
begin
  if recordTable <> nil then
  begin
    recordTable.RemoveRecord(id);
  end;
end;

procedure IActivateRecord(id : integer; activate : boolean);stdcall;
var
  memrec : TMemoryRecord;
begin
  memrec := recordTable.getRecordWithID(id);
  memrec.isSelected:=true;
  if activate then
     recordTable.ActivateSelected(ftFrozen)
  else
     recordTable.DeactivateSelected;
  memrec.isSelected:=false;
end;

procedure IApplyFreeze();stdcall;
begin
  recordTable.ApplyFreeze();
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

procedure ISetValue(id : integer ; value : WideString ; freezer : boolean);stdcall;
var
  memrec : TMemoryRecord;
begin
    memrec := recordTable.getRecordWithID(id);
    memrec.SetValue(value,freezer);
end;

procedure IInitMemoryScanner(hwnd : THandle); stdcall;
begin
  if (assigned(scanner_)) then
  begin
    scanner_.Free;
  end;
  scanner_ := TIScanner.Create(hwnd);
end;

procedure IInitFoundList(vartype: TVariableType; varlength: integer; hexadecimal,
  signed,binaryasdecimal,unicode: boolean); stdcall;
begin
  if assigned(scanner_) then
    scanner_.foundlist.Initialize(vartype,varlength,hexadecimal,signed,binaryasdecimal,unicode,nil);
end;

procedure INewScan();stdcall;
begin
  scanner_.memscan.newscan;
end;

procedure IFirstScan(scanOption: TScanOption; variableType: TVariableType;
  roundingtype: TRoundingType; scanvalue1, scanvalue2: WideString; startaddress,stopaddress: WideString;
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive: boolean; fastscanmethod: TFastScanMethod=fsmNotAligned;
  fastscanparameter: WideString=''); stdcall;
var
  scanstart,scanend : PtrUint;
  v1,v2:string;
begin
  scanstart := StrToQWordEx(startaddress);
  scanend := StrToQWordEx(stopaddress);
  v1 := utf8toansi(scanvalue1);
  v2 := utf8toansi(scanvalue2);
  scanner_.memscan.firstscan(scanOption,variableType,
  roundingtype,v1,v2,scanstart,scanend,
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive,
  fastscanmethod,fastscanparameter,nil);
end;

procedure INextScan(scanOption: TScanOption; roundingtype: TRoundingType;
  scanvalue1, scanvalue2: WideString;
  hexadecimal,binaryStringAsDecimal, unicode, casesensitive,percentage,compareToSavedScan: boolean;
  savedscanname: WideString); stdcall;
var
  v1,v2:string;
begin
  if assigned(scanner_) then
  begin
    scanner_.foundlist.Deinitialize;
    v1 := utf8toansi(scanvalue1);
    v2 := utf8toansi(scanvalue2);
    scanner_.memscan.nextscan(scanOption,
    roundingtype, v1,v2,
    hexadecimal,binaryStringAsDecimal,unicode,casesensitive,
    percentage,compareToSavedScan,'');
  end;
end;

function ICountAddressesFound():uint64; stdcall;
begin
  if assigned(scanner_) then
    result := scanner_.memscan.GetFoundCount
  else result := -1;
end;

procedure IGetAddress(i: qword;out address: WideString; out value: WideString)stdcall;
var
  address_ : PtrUint;
  value_ : string;
  extra : dword;
begin
  if assigned(scanner_) then
  begin
    address_ := scanner_.foundlist.GetAddress(i,extra,value_);
    address := IntToHex(address_,8);
    value := value_;
  end
  else begin
    address := 'null';
    value := 'null';
  end;

end;

procedure IResetValues;stdcall;
begin
  if (assigned(scanner_)) and (assigned(scanner_.foundlist)) then
  scanner_.foundlist.ResetValues;
end;

procedure IRebaseAddressList(index : integer);stdcall;
begin
  if (assigned(scanner_)) then
  scanner_.foundlist.RebaseAddresslist(index);
end;

function IGetBinarySize():integer;stdcall;
begin
  if (assigned(scanner_)) and (assigned(scanner_.memscan)) then
     result := scanner_.memscan.Getbinarysize()
  else
  result := -1;
end;

procedure IConfigScanner(scanWritable: Tscanregionpreference;
  scanExecutable: Tscanregionpreference;scanCopyOnWrite: Tscanregionpreference);stdcall;
begin
  if (assigned(scanner_)) and (assigned(scanner_.memscan)) then
  begin
       scanner_.memscan.scanWritable:= scanWritable;
       scanner_.memscan.scanExecutable:= scanExecutable;
       scanner_.memscan.scanCopyOnWrite:= scanCopyOnWrite;
  end;
end;

end.

