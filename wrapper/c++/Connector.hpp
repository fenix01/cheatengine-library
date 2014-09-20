#ifndef CONNECTOR_HPP
#define CONNECTOR_HPP
#include <atlbase.h>

enum TScanOption { soUnknownValue = 0, soExactValue = 1, soValueBetween = 2, soBiggerThan = 3, soSmallerThan = 4, soIncreasedValue = 5, soIncreasedValueBy = 6, soDecreasedValue = 7, soDecreasedValueBy = 8, soChanged = 9, soUnchanged = 10, soCustom };
enum TScanType { stNewScan, stFirstScan, stNextScan };
enum TRoundingType { rtRounded = 0, rtExtremerounded = 1, rtTruncated = 2 };
enum TVariableType { vtByte = 0, vtWord = 1, vtDword = 2, vtQword = 3, vtSingle = 4, vtDouble = 5, vtString = 6, vtUnicodeString = 7, vtByteArray = 8, vtBinary = 9, vtAll = 10, vtAutoAssembler = 11, vtPointer = 12, vtCustom = 13, vtGrouped = 14, vtByteArrays = 15 }; //all ,grouped and MultiByteArray are special types
enum TCustomScanType { cstNone, cstAutoAssembler, cstCPP, cstDLLFunction };
enum TFastScanMethod { fsmNotAligned = 0, fsmAligned = 1, fsmLastDigits = 2 };
enum Tscanregionpreference { scanDontCare, scanExclude, scanInclude };


typedef void(__stdcall *IGetProcessList)(BSTR &processes);
typedef void(__stdcall *IOpenProcess)(BSTR pid);

typedef void(__stdcall *IResetTable)();
typedef void(__stdcall *IAddScript)(BSTR name, BSTR script);
typedef void(__stdcall *IActivateRecord)(int id, bool activate);
typedef void(__stdcall *IRemoveRecord)(int id);
typedef void(__stdcall *IApplyFreeze)();

typedef void(__stdcall *IAddAddressManually)(BSTR initialaddress, TVariableType vartype);
typedef void(__stdcall *IGetValue)(int id, BSTR &value);
typedef void(__stdcall *ISetValue)(int id, BSTR value, bool freezer);
typedef void(__stdcall *IProcessAddress)(BSTR address, TVariableType vartype, bool showashexadecimal, bool showassigned , int bytesize, BSTR &res_address);

typedef void(__stdcall *IInitMemoryScanner)(HWND hwnd);
typedef void(__stdcall *INewScan)();
typedef void(__stdcall *IConfigScanner)(Tscanregionpreference scanWritable, Tscanregionpreference scanExecutable, Tscanregionpreference scanCopyOnWrite);

typedef void(__stdcall *IFirstScan)(TScanOption scanOption, TVariableType variableType,
	TRoundingType roundingtype, BSTR scanvalue1, BSTR scanvalue2,
	BSTR startaddress, BSTR stopaddress, bool hexadecimal, bool binaryStringAsDecimal,
	bool unicode, bool casesensitive, TFastScanMethod fastscanmethod,
	BSTR fastscanparameter);

typedef void(__stdcall *INextScan)(TScanOption scanOption, TRoundingType roundingtype, 
	BSTR scanvalue1, BSTR scanvalue2, bool hexadecimal, bool binaryStringAsDecimal,
	bool unicode, bool casesensitive, bool percentage, bool compareToSavedScan, 
	BSTR savedscanname);

typedef long long(__stdcall *ICountAddressesFound)();
typedef void(__stdcall *IGetAddress)(long long index, BSTR &address, BSTR &value);
typedef void(__stdcall *IInitFoundList)(TVariableType vartype, int varlength, 
	bool hexadecimal, bool signed_, bool binaryasdecimal, bool unicode);
typedef void(__stdcall *IResetValues)();
typedef void(__stdcall *IRebaseAddressList)(int index);
typedef void(__stdcall *IGetBinarySize)();


extern IGetProcessList iGetProcessList;
extern IOpenProcess iOpenProcess;

extern IResetTable iResetTable;
extern IAddScript iAddScript;
extern IActivateRecord iActivateRecord;
extern IRemoveRecord iRemoveRecord;
extern IApplyFreeze;

extern IAddAddressManually iAddAddressManually;
extern IGetValue iGetValue;
extern ISetValue iSetValue;
extern IProcessAddress iProcessAddress;

extern IInitMemoryScanner iInitMemoryScanner;
extern INewScan iNewScan;
extern IConfigScanner iConfigScanner;
extern IFirstScan iFirstScan;
extern INextScan iNextScan;
extern ICountAddressesFound iCountAddressesFound;
extern IGetAddress iGetAddress;
extern IInitFoundList iInitFoundList;
extern IResetValues iResetValues;
extern IRebaseAddressList iRebaseAddressList;
extern IGetBinarySize iGetBinarySize;



void loadFunctions(HINSTANCE libInst);

#endif