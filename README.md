############################ ANNOUNCE (30/07/2016) ############################

YOU HAVE PROBABLY NOTICE THAT THIS PROJECT HAS NOT BEEN UPDATED FOR A WHILE. YOU WERE PROBABLY LOOKING FOR UPDATES BUT I DON'T HAVE THE TIME TO CREATE NEW VERSIONS. IT HAS BEEN FOR ME A TIME-CONSUMING PROJECT.
I'M SORRY TO LET YOU KNOW THAT THIS PROJECT WILL NOT RECEIVE ANY BUG FIXES OR UPDATES IN THE FUTURE.
THE WEBSITE CHEATALK.COM WILL BE REMOVED VERY SOON BUT THE PROJECT WILL STILL BE AVAILABLE ON GITHUB.
IF ANYONE IS INTERESTED IN PURSUING THIS PROJECT YOU CAN FORK THE SOURCE CODE (JUST REMEMBER : IT'S OPEN SOURCE AND THE ORIGINAL PROJECT WAS INITIATED BY DARK BYTE : http://www.cheatengine.org/)

IF YOU WANT TO CONTACT ME YOU CAN SEND ME A MAIL : p-yohann@hotmail.fr

THANKS TO ALL WHO WERE SUPPORTING THIS PROJECT,

BEST REGARDS.

FENIX

###############################################################################


cheatengine-library
===================

Cheat Engine Library is the first open source library based on Cheat Engine a powerfull memory editing software. You may found the original software here http://cheatengine.org/

The first goal of this project is to give you the ability to make your own software with advanced features like auto assemble, dll injections, memory scanner etc. As you know, Cheat Engine doesn't provide any library and it could be very frustrating for a developer. This library is supported for both platform (x86/x64) and it is usable with popular programming languages (c#, c++, delphi).

![scanner_c](https://cloud.githubusercontent.com/assets/5822286/3718740/268557f8-163a-11e4-8585-ad3105b28859.png)

##Features :
* **manage a virtual cheat engine table**
 * add an address manually
 * add an autoassemble script
 * activate, desactivate, freeze and unfreeze any address or script
* **inject auto assemble script**
 * **supported symbols :**
    * ALLOC
    * DEALLOC
    * LABEL
    * DEFINE
    * REGISTERSYMBOL
    * UNREGISTERSYMBOL
    * INCLUDE
    * READMEM
    * LOADLIBRARY
    * CREATETHREAD
* **Scan the memory to find specific addresses**
 * **Scan type :**
    * Exact value
    * Smaller than
    * Bigger than
    * Value between
    * Unknown initial value
    * Increase value
    * Increase value by
    * Decrease value
    * Decrease value by
    * Changed value
    * Unchanged value
 * **Value type :**
    * Binary
    * Byte
    * 2 Bytes
    * 4 Bytes
    * 8 Bytes
    * Float
    * Double
    * String
  * **Memory scan options :**
    * Start address, Stop address
    * Writable, Executable, CopyOnWrite
    * Fast scan, Align and Not Align
    * Unicode, Case Sensitive

##What's new ?
**Please refer to the CHANGELOG file to get informations about the last release**

##Where should I begin ?

1. If you need an turnkey solution you should download :
 * one example (delphi, c#, or c++)
 * a wrapper for communicating with the library
 * the library available in the release page : https://github.com/fenix01/cheatengine-library/releases

2. If you need your own solution :
 * Download Lazarus 64 bits or Lazarus 32 bits
 * Copy the library and the dll directory

##Do you provide a documentation ?

Yes, I made a description of the cheat engine library apis. Follow this link https://github.com/fenix01/cheatengine-library/wiki/Guideline
