cheatengine-library
===================

Cheat Engine Library is a small library based on Cheat Engine a powerfull memory editing software. You may found it here http://cheatengine.org/

The first goal of this project is to give you the ability to make your own software with advanced features like auto assemble, dll injections, etc. You may be able to embed cheat engine library in a dll or anything else and avoid common detections.

Features :
- inject asm scripts
- only a few symbols are support : 
    ALLOC
    DEALLOC
    LABEL
    DEFINE
    REGISTERSYMBOL
    UNREGISTERSYMBOL
    INCLUDE
    READMEM
    LOADLIBRARY

How to compile ?

- Download Lazarus 64 bits
- Copy the library and the exemple directory and compile
