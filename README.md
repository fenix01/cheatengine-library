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

1.1.0:
- adding the memory scanner

1.0.1 :
- adding a c#wrapper and a c# example

1.0.0 :
- adding the compiled library in the release page
- adding a dll directory for anyone who wants to customize this dll
- adding a wrapper directory that contains headers for various programming languages. (c++, delphi, c#)
- adding a c++ example to call the dll
- adding a new function to the library to remove a script 

0.9.9 :
- adding the source code for cheatengine-library
- starting the cheat engine library project

Where should I begin ?

1) If you need an turnkey solution you should download :
- one example (delphi, c#, or c++)
- a wrapper for communicating with the dll
- the library available in the release page : https://github.com/fenix01/cheatengine-library/releases

2) If you need your own solution :

- Download Lazarus 64 bits
- Copy the library and the dll directory
