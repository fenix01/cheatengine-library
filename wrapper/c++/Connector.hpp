#ifndef CONNECTOR_HPP
#define CONNECTOR_HPP
#include <atlbase.h>

enum VariableType {
	vtByte = 0,
	vtWord = 1,
	vtDword = 2,
	vtQword = 3,
	vtSingle = 4,
	vtDouble = 5,
	vtString = 6,
	vtUnicodeString = 7,
	vtByteArray = 8,
	vtBinary = 9,
	vtAll = 10,
	vtAutoAssembler = 11,
	vtPointer = 12,
	vtCustom = 13,
	vtGrouped = 14,
	vtByteArrays = 15
}; //all ,grouped and MultiByteArray are special types


typedef void(__stdcall *IGetProcessList)(BSTR &processes);
typedef void(__stdcall *IOpenProcess)(BSTR pid);

typedef void(__stdcall *IResetScripts)();
typedef void(__stdcall *IAddScript)(BSTR name, BSTR script);
typedef void(__stdcall *IRemoveScript)(int id);
typedef void(__stdcall *IActivateScript)(int id, bool activate);

typedef void(__stdcall *IProcessAddress)(BSTR address, VariableType vartype, bool showashexadecimal, bool showassigned , int bytesize, BSTR &res_address);
typedef void(__stdcall *IAddAddressManually)(BSTR initialaddress, VariableType vartype);
typedef void(__stdcall *IGetValue)(int id, BSTR &value);

extern IGetProcessList iGetProcessList;
extern IOpenProcess iOpenProcess;
extern IResetScripts iResetScripts;
extern IAddScript iAddScript;
extern IRemoveScript iRemoveScript;
extern IActivateScript iActivateScript;

extern IProcessAddress iProcessAddress;
extern IAddAddressManually iAddAddressManually;
extern IGetValue iGetValue;

void loadFunctions(HINSTANCE libInst);

#endif