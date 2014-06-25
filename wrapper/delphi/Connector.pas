unit Connector;

interface

uses System.SysUtils, System.Variants, System.Classes,windows;

type TOnScanDoneCallback = procedure ();

type TScanOption=(soUnknownValue=0,soExactValue=1,soValueBetween=2,soBiggerThan=3,soSmallerThan=4, soIncreasedValue=5, soIncreasedValueBy=6, soDecreasedValue=7, soDecreasedValueBy=8, soChanged=9, soUnchanged=10, soCustom);
type TScanType=(stNewScan, stFirstScan, stNextScan);
type TRoundingType=(rtRounded=0,rtExtremerounded=1,rtTruncated=2);
type TVariableType=(vtByte=0, vtWord=1, vtDword=2, vtQword=3, vtSingle=4, vtDouble=5, vtString=6, vtUnicodeString=7, vtByteArray=8, vtBinary=9, vtAll=10, vtAutoAssembler=11, vtPointer=12, vtCustom=13, vtGrouped=14, vtByteArrays=15); //all ,grouped and MultiByteArray are special types
type TCustomScanType=(cstNone, cstAutoAssembler, cstCPP, cstDLLFunction);
type TFastScanMethod=(fsmNotAligned=0, fsmAligned=1, fsmLastDigits=2);

type
  TGetProcessList = procedure(out processes : WideString); stdcall;
  TOpenProcess = procedure(pid: WideString); stdcall;

  TResetScripts = procedure(); stdcall;
  TAddScript = procedure(name: WideString; script: WideString); stdcall;
  TRemoveScript = procedure(id: integer); stdcall;
  TActivateScript = procedure(id: integer; activate: boolean); stdcall;

  TProcessAddress = procedure(address : WideString ; vartype : TVariableType ; showashexadecimal: boolean;
  showAsSigned: boolean; bytesize: Integer; out pvalue : WideString);stdcall;
  TAddAddressManually = procedure (initialaddress: WideString=''; vartype: TVariableType=vtDword);stdcall;
  TGetValue = procedure (id : integer ; out value : WideString);stdcall;

  TInitMemoryScanner = procedure();stdcall;
  TDeinitMemoryScanner = procedure();stdcall;

  TFirstScan = procedure(scanOption: TScanOption; VariableType: TVariableType;
  roundingtype: TRoundingType; scanvalue1, scanvalue2: WideString; startaddress,stopaddress: WideString;
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive: boolean; fastscanmethod: TFastScanMethod=fsmNotAligned;
  fastscanparameter: WideString=''); stdcall;

  TNextScan = procedure (scanOption: TScanOption; roundingtype: TRoundingType;
  scanvalue1, scanvalue2: string;
  hexadecimal,binaryStringAsDecimal, unicode, casesensitive,percentage,compareToSavedScan: boolean;
  savedscanname: string); stdcall;

  TCountAddressesFound = function():Int64;stdcall;
  TRegisterScanDoneCallback = procedure(fun : TOnScanDoneCallback);stdcall;
  TInitializeFoundList = procedure();stdcall;
  TGetAddress = procedure(index : integer; out address : WideString ; out value : WideString);

var
  IGetProcessList: TGetProcessList;
  IOpenProcess: TOpenProcess;
  IResetScripts: TResetScripts;
  IAddScript: TAddScript;
  IRemoveScript: TRemoveScript;
  IActivateScript: TActivateScript;

  IProcessAddress : TProcessAddress;
  IAddAddressManually : TAddAddressManually;
  IGetValue : TGetValue;

  IInitMemoryScanner : TInitMemoryScanner;
  IDeinitMemoryScanner : TDeinitMemoryScanner;
  IFirstScan : TFirstScan;
  INextScan : TNextScan;
  ICountAddressesFound : TCountAddressesFound;
  IRegisterScanDoneCallback : TRegisterScanDoneCallback;
  IInitializeFoundList : TInitializeFoundList;
  IGetAddress : TGetAddress;

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

  @IProcessAddress := GetProcAddress(handle, 'IProcessAddress');
  @IAddAddressManually := GetProcAddress(handle, 'IAddAddressManually');
  @IGetValue := GetProcAddress(handle, 'IGetValue');

  @IInitMemoryScanner := GetProcAddress(handle, 'IInitMemoryScanner');
  @IDeinitMemoryScanner := GetProcAddress(handle, 'IDeinitMemoryScanner');
  @IFirstScan := GetProcAddress(handle, 'IFirstScan');
  @INextScan := GetProcAddress(handle, 'INextScan');
  @ICountAddressesFound := GetProcAddress(handle, 'ICountAddressesFound');
  @IRegisterScanDoneCallback := GetProcAddress(handle, 'IRegisterScanDoneCallback');
  @IInitializeFoundList := GetProcAddress(handle, 'IInitializeFoundList');
  @IGetAddress := GetProcAddress(handle, 'IGetAddress');
end;

end.
