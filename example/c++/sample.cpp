#include <Windows.h>
#include <string>
#include <iostream>
#include "..\..\wrapper\c++\Connector.hpp"

using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	//load the cheat engine library
	HINSTANCE libInst;

	//don't forget to put the dll the same directory
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

	//add a script to the 
	BSTR name = ::SysAllocString(L"example");//name of the script

	//Don't try to run this script or you will get an exception.
	//this script is just an example. 
	//It's a hook script for the MessageBox api.
	BSTR script = ::SysAllocString(
		L"[enable]\r\n"
		L"alloc(hook, 1024)\r\n"
		L"hook:\r\n"
		L"db 49 4C EB 76\r\n"
		L"db 68 00 6F 00 6F 00 6B 00 20 00 21 00 00 00\r\n"
		L"pop eax\r\n"
		L"add esp, 10\r\n"
		L"push 30\r\n"
		L"push hook+4\r\n"
		L"push hook+4\r\n"
		L"push 0\r\n"
		L"push eax\r\n"
		L"jmp [hook]\r\n"
		L"0042434C:\r\n"
		L"dd hook+12\r\n"
		L"[disable]\r\n"
		L"0042434C :\r\n"
		L"db 49 4C EB 76\r\n"
		L"dealloc(hook)");//the auto assemble script
	iAddScript(name, script);
	iRemoveScript(0);
	iAddScript(name, script);
	iActivateScript(0, true);

	system("PAUSE");
	FreeLibrary(libInst);
	return 0;
}

