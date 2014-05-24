#include <Windows.h>
#include <string>
#include <iostream>
#include "..\..\..\wrapper\c++\Connector.hpp"

using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	//load the cheat engine library
	HINSTANCE libInst;

	//don't forget to put the dll in the same directory
#ifdef _WIN64
	libInst = LoadLibraryW(L"ce-lib64.dll");
#else
	libInst = LoadLibrary("ce-lib32.dll");
#endif

	loadFunctions(libInst);

	//get all running processes and print the list
	BSTR proc;
	iGetProcessList(proc);
	wcout << proc;

	BSTR pid = ::SysAllocString(L"00000000");
	cout << "put the pid of the process\r\n";
	wcin >> pid; //don't forget to put the eight digit like 00000000
	wcout << pid << "\r\n";
	iOpenProcess(pid);//open running process by pid

	BSTR address = ::SysAllocString(L"00400000");
	BSTR res_addr;
	iProcessAddress(address, vtDword,false,false,1,res_addr);
	wcout << res_addr << "\r\n";

	system("PAUSE");
	FreeLibrary(libInst);
	return 0;
}

