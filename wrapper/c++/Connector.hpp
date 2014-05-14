#ifndef CONNECTOR_HPP
#define CONNECTOR_HPP
#include <atlbase.h>

typedef void(__stdcall *IGetProcessList)(BSTR &processes);
typedef void(__stdcall *IOpenProcess)(BSTR pid);
typedef void(__stdcall *IResetScripts)();
typedef void(__stdcall *IAddScript)(BSTR name, BSTR script);
typedef void(__stdcall *IRemoveScript)(int id);
typedef void(__stdcall *IActivateScript)(int id, bool activate);

extern IGetProcessList iGetProcessList;
extern IOpenProcess iOpenProcess;
extern IResetScripts iResetScripts;
extern IAddScript iAddScript;
extern IRemoveScript iRemoveScript;
extern IActivateScript iActivateScript;

void loadFunctions(HINSTANCE libInst);

#endif