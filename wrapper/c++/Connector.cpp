#include "Connector.hpp"

IGetProcessList iGetProcessList = 0;
IOpenProcess iOpenProcess = 0;

IResetTable iResetTable = 0;
IAddScript iAddScript = 0;
IRemoveRecord iRemoveRecord = 0;
IActivateRecord iActivateRecord = 0;
IApplyFreeze iApplyFreeze;

IAddAddressManually iAddAddressManually = 0;
IGetValue iGetValue = 0;
ISetValue iSetValue = 0;
IProcessAddress iProcessAddress = 0;

IInitMemoryScanner iInitMemoryScanner = 0;
INewScan iNewScan = 0;
IConfigScanner iConfigScanner = 0;
IFirstScan iFirstScan = 0;
INextScan iNextScan = 0;
ICountAddressesFound iCountAddressesFound = 0;
IGetAddress iGetAddress = 0;
IInitFoundList iInitFoundList = 0;
IResetValues iResetValues = 0;
IGetBinarySize iGetBinarySize = 0;




void loadFunctions(HINSTANCE libInst){
	if (libInst){
		iGetProcessList = (IGetProcessList)GetProcAddress(libInst, "IGetProcessList");
		iOpenProcess = (IOpenProcess)GetProcAddress(libInst, "IOpenProcess");

		iResetTable = (IResetTable)GetProcAddress(libInst, "IResetTable");
		iAddScript = (IAddScript)GetProcAddress(libInst, "IAddScript");
		iRemoveRecord = (IRemoveRecord)GetProcAddress(libInst, "IRemoveRecord");
		iActivateRecord = (IActivateRecord)GetProcAddress(libInst, "IActivateRecord");
		iApplyFreeze = (IApplyFreeze)GetProcAddress(libInst, "IApplyFreeze");


		iAddAddressManually = (IAddAddressManually)GetProcAddress(libInst, "IAddAddressManually");
		iGetValue = (IGetValue)GetProcAddress(libInst, "IGetValue");
		iSetValue = (ISetValue)GetProcAddress(libInst, "ISetValue");
		iProcessAddress = (IProcessAddress)GetProcAddress(libInst, "IProcessAddress");
		
		iInitMemoryScanner = (IInitMemoryScanner)GetProcAddress(libInst, "IInitMemoryScanner");
		iNewScan = (INewScan)GetProcAddress(libInst, "INewScan");
		iConfigScanner = (IConfigScanner)GetProcAddress(libInst, "IConfigScanner");
		iFirstScan = (IFirstScan)GetProcAddress(libInst, "IFirstScan");
		iNextScan = (INextScan)GetProcAddress(libInst, "INextScan");
		iCountAddressesFound = (ICountAddressesFound)GetProcAddress(libInst, "ICountAddressesFound");
		iGetAddress = (IGetAddress)GetProcAddress(libInst, "IGetAddress");
		iInitFoundList = (IInitFoundList)GetProcAddress(libInst, "IInitFoundList");
		iResetValues = (IResetValues)GetProcAddress(libInst, "IResetValues");
		iGetBinarySize = (IGetBinarySize)GetProcAddress(libInst, "IGetBinarySize");
	}
}