#include "Connector.hpp"

IGetProcessList iGetProcessList = 0;
IOpenProcess iOpenProcess = 0;
IResetScripts iResetScripts = 0;
IAddScript iAddScript = 0;
IRemoveScript iRemoveScript = 0;
IActivateScript iActivateScript = 0;

void loadFunctions(HINSTANCE libInst){
	if (libInst){
		iGetProcessList = (IGetProcessList)GetProcAddress(libInst, "IGetProcessList");
		iOpenProcess = (IOpenProcess)GetProcAddress(libInst, "IOpenProcess");
		iResetScripts = (IResetScripts)GetProcAddress(libInst, "IResetScripts");
		iAddScript = (IAddScript)GetProcAddress(libInst, "IAddScript");
		iRemoveScript = (IRemoveScript)GetProcAddress(libInst, "IRemoveScript");
		iActivateScript = (IActivateScript)GetProcAddress(libInst, "IActivateScript");
	}
}