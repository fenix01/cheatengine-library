cheatengine-library
===================

Cheat Engine Library is a small library based on Cheat Engine a powerfull memory editing software. You may found it here http://cheatengine.org/

The first goal of this project is to give you the ability to make your own software with advanced features like auto assemble, dll injections, etc. You may be able to embed cheat engine library in a dll or anything else and avoid common detections.

Features :
- manage a virtual cheat engine table
- inject asm scripts
- only these symbols are support : 
    ALLOC
    DEALLOC
    LABEL
    DEFINE
    REGISTERSYMBOL
    UNREGISTERSYMBOL
    INCLUDE
    READMEM
    LOADLIBRARY
- scan the memory to find specific addresses

1.2.0:
	the memory scanner is now fully supported
	+added a memory scanner example for c# and delphi
	+added new functions : 
		INewScan, IConfigScanner, IResetTable, IRemoveRecord, IActivateRecord, 
		IApplyFreeze, ISetValue, IInitFoundList, IResetValues, IRebaseAddressList,
		IGetBinarySize
	-removed :
		IResetScripts, IRemoveScript, IActivateScript, IRegisterScanDoneCallback,
		IInitializeFoundList, IDeinitMemoryScanner
	*updated :
		IInitMemoryScanner, INextScan
	*updated the lazarus memory scanner example
	*updated all wrappers (c#, delphi, c++)

1.1.0:
    this version is an alpha release of the memory scanner
	+added a new set of functions to controls the memory scanner and the virtual cheat table :
		IAddAddressManually, IGetValue, IInitMemoryScanner, IDeinitMemoryScanner, IFirstScan,
		INextScan, ICountAddressesFound, IRegisterScanDoneCallback, IInitializeFoundList, IGetAddress

1.0.0 :
    +added the compiled library in the release page
    +added a dll directory for anyone who wants to customize this dll
    +added a wrapper directory that contains headers for various programming languages. (c++, delphi, c#)
    +added a c++ example to call the dll
    +added a new API : RemoveScript

0.9.9 :
    started the cheat engine library project
	+added the source code for the cheatengine-library
	+API : IGetProcessList, IOpenProcess, IResetScripts, IAddScript, IActivateScript

Where should I begin ?

1) If you need an turnkey solution you should download :
- one example (delphi, c#, or c++)
- a wrapper for communicating with the dll
- the library available in the release page : https://github.com/fenix01/cheatengine-library/releases

2) If you need your own solution :

- Download Lazarus 64 bits
- Copy the library and the dll directory
