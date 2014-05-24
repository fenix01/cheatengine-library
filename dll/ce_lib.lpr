library ce_lib;

{$mode objfpc}{$H+}

uses
  windows, Interfaces, SysUtils, Classes, Assemblerunit, autoassembler,
  byteinterpreter, CEFuncProc, CustomTypeHandler, cvconst, DriverList,
  fileaccess, Filehandler, FileMapping, genericHotkey, hotkeyhandler, hypermode,
  memoryrecorddatabase, MemoryRecordUnit, NewKernelHandler, ProcessHandlerUnit,
  savedscanhandler, symbolhandler, symbollisthandler, PEInfounit, connector,
  AddressChangeUnit, settings
  { you can add units after this };

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
          //Failure setting the debug privilege. Debugging may be limited.
      end;


      ZeroMemory(@tp, sizeof(tp));
      if lookupPrivilegeValue(nil, SE_LOAD_DRIVER_NAME, tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          //Failure setting the load driver privilege. Debugging may be limited.
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
            //Failure setting the CreateGlobal privilege.
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


Exports
//ILoadCommonModuleList,
//IGetModuleList,
IGetProcessList,
IOpenProcess,

IResetScripts,
IAddScript,
IActivateScript,
IRemoveScript,

IAddAddressManually,
IGetValue,
IProcessAddress;

{$R *.res}

begin
     AdjustPrivilege();
     symhandlerInitialize;
     symhandler.loadCommonModuleList;
end.

