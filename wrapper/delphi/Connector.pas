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
type Tscanregionpreference=(scanDontCare, scanExclude, scanInclude);

type
  TGetProcessList = procedure(out processes : WideString); stdcall;
  TOpenProcess = procedure(pid: WideString); stdcall;

  TResetTable = procedure(); stdcall;
  TAddScript = procedure(name: WideString; script: WideString); stdcall;
  TActivateRecord = procedure(id: integer; activate: boolean); stdcall;
  TRemoveRecord = procedure(id: integer); stdcall;

  TAddAddressManually = procedure (initialaddress: WideString=''; vartype: TVariableType=vtDword);stdcall;
  TGetValue = procedure(id : integer ; out value : WideString);stdcall;
  TSetValue = procedure(id : integer ; value : WideString ; freezer : boolean);stdcall;
  TProcessAddress = procedure(address : WideString ; vartype : TVariableType ; showashexadecimal: boolean;
  showAsSigned: boolean; bytesize: Integer; out pvalue : WideString);stdcall;

  TInitMemoryScanner = procedure(hwnd : THandle);stdcall;
  TNewScan = procedure();stdcall;
  TConfigScanner = procedure (scanWritable: Tscanregionpreference;
  scanExecutable: Tscanregionpreference;scanCopyOnWrite: Tscanregionpreference);stdcall;

  TFirstScan = procedure(scanOption: TScanOption; VariableType: TVariableType;
  roundingtype: TRoundingType; scanvalue1, scanvalue2: WideString; startaddress,stopaddress: WideString;
  hexadecimal,binaryStringAsDecimal,unicode,casesensitive: boolean; fastscanmethod: TFastScanMethod=fsmNotAligned;
  fastscanparameter: WideString=''); stdcall;

  TNextScan = procedure (scanOption: TScanOption; roundingtype: TRoundingType;
  scanvalue1, scanvalue2: WideString;
  hexadecimal,binaryStringAsDecimal, unicode, casesensitive,percentage,compareToSavedScan: boolean;
  savedscanname: WideString); stdcall;

  TCountAddressesFound = function():Int64;stdcall;
  TGetAddress = procedure(index : integer; out address : WideString ; out value : WideString);
  TInitFoundList = procedure (vartype: TVariableType; varlength: integer; hexadecimal,
  signed,binaryasdecimal,unicode: boolean);stdcall;
  TResetValues = procedure();stdcall;
  TRebaseAddressList = procedure(index : integer);stdcall;
  TGetBinarySize = function():Int64;stdcall;

var
  IGetProcessList: TGetProcessList;
  IOpenProcess: TOpenProcess;
  IResetTable: TResetTable;
  IAddScript: TAddScript;
  IRemoveRecord: TRemoveRecord;
  IActivateRecord: TActivateRecord;

  IProcessAddress : TProcessAddress;
  IAddAddressManually : TAddAddressManually;
  IGetValue : TGetValue;
  ISetValue : TSetValue;

  IInitMemoryScanner : TInitMemoryScanner;
  IConfigScanner : TConfigScanner;
  INewScan : TNewScan;
  IFirstScan : TFirstScan;
  INextScan : TNextScan;
  ICountAddressesFound : TCountAddressesFound;
  IGetAddress : TGetAddress;
  IInitFoundList : TInitFoundList;
  IResetValues : TResetValues;
  IRebaseAddressList : TRebaseAddressList;
  IGetBinarySize : TGetBinarySize;

procedure loadFunctions(handle: THandle);

implementation

procedure loadFunctions(handle: THandle);
begin
  @IGetProcessList := GetProcAddress(handle, 'IGetProcessList');
  @IOpenProcess := GetProcAddress(handle, 'IOpenProcess');

  @IResetTable := GetProcAddress(handle, 'IResetTable');
  @IAddScript := GetProcAddress(handle, 'IAddScript');
  @IActivateRecord := GetProcAddress(handle, 'IActivateScript');
  @IRemoveRecord := GetProcAddress(handle, 'IRemoveScript');

  @IAddAddressManually := GetProcAddress(handle, 'IAddAddressManually');
  @IGetValue := GetProcAddress(handle, 'IGetValue');
  @ISetValue := GetProcAddress(handle, 'ISetValue');
  @IProcessAddress := GetProcAddress(handle, 'IProcessAddress');

  @IInitMemoryScanner := GetProcAddress(handle, 'IInitMemoryScanner');
  @INewScan := GetProcAddress(handle, 'INewScan');
  @IConfigScanner := GetProcAddress(handle, 'IConfigScanner');
  @IFirstScan := GetProcAddress(handle, 'IFirstScan');
  @INextScan := GetProcAddress(handle, 'INextScan');
  @ICountAddressesFound := GetProcAddress(handle, 'ICountAddressesFound');
  @IGetAddress := GetProcAddress(handle, 'IGetAddress');
  @IInitFoundList := GetProcAddress(handle, 'IInitFoundList');
  @IResetValues := GetProcAddress(handle, 'IResetValues');
  @IRebaseAddressList := GetProcAddress(handle, 'IRebaseAddressList');
  @IGetBinarySize := GetProcAddress(handle, 'IGetBinarySize');
end;

end.
