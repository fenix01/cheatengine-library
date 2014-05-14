unit Connector;

interface

uses windows;

type
  TGetProcessList = function(): WideString; stdcall;
  TOpenProcess = procedure(pid: WideString); stdcall;
  TResetScripts = procedure(); stdcall;
  TAddScript = procedure(name: WideString; script: WideString); stdcall;
  TRemoveScript = procedure(id: integer); stdcall;
  TActivateScript = procedure(id: integer; activate: boolean); stdcall;

var
  IGetProcessList: TGetProcessList;
  IOpenProcess: TOpenProcess;
  IResetScripts: TResetScripts;
  IAddScript: TAddScript;
  IRemoveScript: TRemoveScript;
  IActivateScript: TActivateScript;

procedure loadFunctions(handle: THandle);

implementation

procedure loadFunctions(handle: THandle);
begin
  @IGetProcessList := GetProcAddress(handle, 'IGetProcessList');
  @IOpenProcess := GetProcAddress(handle, 'IOpenProcess');
  @IResetScripts := GetProcAddress(handle, 'IResetScripts');
  @IAddScript := GetProcAddress(handle, 'IAddScript');
  @IRemoveScript := GetProcAddress(handle, 'IRemoveScript');
  @IActivateScript := GetProcAddress(handle, 'IActivateScript');
end;

end.
