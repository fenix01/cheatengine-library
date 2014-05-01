unit PEInfounit;

{$mode DELPHI}

{
Changed title from PE info to Portable Executable (PE) info. I have this feeling
that 'some people' (idiots) would not understand that it isn't a packet editor
}

interface

uses
  windows, LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CEFuncProc, NewKernelHandler, Buttons, StdCtrls, ExtCtrls,
  ComCtrls, LResources, symbolhandler, PEInfoFunctions, FGL, Imagehlp;

type
  TPEInfo = class
    imageBase : DWORD;
    is64bit: boolean;
    ImageDosHeader: PImageDosHeader;
    ImageNTHeader: PImageNtHeaders;
    ImageSectionHeader: PImageSectionHeader;
    ImageBaseRelocation: PIMAGE_BASE_RELOCATION;
    ImageExportDirectory: PImageExportDirectory;
    ImageImportAddresses: TListImportAddresses;
    ImageDebugDirectory: PImageDebugDirectory;
    procedure setModule(index : integer);
    procedure getPE();
    procedure ParsePE(loaded: boolean);

  private
    { Private declarations }
    mod_addr : string;
    memorycopy: pbytearray;
    memorycopysize: dword;
    modulebase: dword;
    loadedmodule: pbytearray;
    modules : TStrings;
  public
    { Public declarations }
    constructor Create(moduleList : TStrings);
    destructor Destroy;
  end;

function peinfo_getcodesize(header: pointer; headersize: integer=0): dword;
function peinfo_getentryPoint(header: pointer; headersize: integer=0): ptrUint;
function peinfo_getcodebase(header: pointer; headersize: integer=0): ptrUint;
function peinfo_getdatabase(header: pointer; headersize: integer=0): ptrUint;
function peinfo_getheadersize(header: pointer): dword;


implementation

uses Main;

resourcestring
  rsThisIsNotAValidImage = 'This is not a valid image';



function peinfo_getcodesize(header: pointer; headersize: integer=0): dword;
var
    ImageNTHeader: PImageNtHeaders;
begin
  result:=0;

  if (headersize=0) or (PImageDosHeader(header)^._lfanew<=headersize-sizeof(TImageNtHeaders)) then
  begin
    ImageNTHeader:=PImageNtHeaders(ptrUint(header)+PImageDosHeader(header)^._lfanew);
    result:=ImageNTHeader.OptionalHeader.SizeOfCode;
  end;
end;

function peinfo_getdatabase(header: pointer; headersize: integer=0): ptrUint;
var
    ImageNTHeader: PImageNtHeaders;
begin
  result:=0;
  if (headersize=0) or (PImageDosHeader(header)^._lfanew<=headersize-sizeof(TImageNtHeaders)) then
  begin
    ImageNTHeader:=PImageNtHeaders(ptrUint(header)+PImageDosHeader(header)^._lfanew);
    result:=ImageNTHeader.OptionalHeader.BaseOfData;
  end;
end;

function peinfo_getcodebase(header: pointer; headersize: integer=0): ptrUint;
var
    ImageNTHeader: PImageNtHeaders;
begin
  result:=0;
  if (headersize=0) or (PImageDosHeader(header)^._lfanew<=headersize-sizeof(TImageNtHeaders)) then
  begin
    ImageNTHeader:=PImageNtHeaders(ptrUint(header)+PImageDosHeader(header)^._lfanew);
    result:=ImageNTHeader.OptionalHeader.BaseOfCode;
  end;
end;

function peinfo_getEntryPoint(header: pointer; headersize: integer=0): ptrUint;
var
    ImageNTHeader: PImageNtHeaders;
begin
  result:=0;
  if (headersize=0) or (PImageDosHeader(header)^._lfanew<=headersize-sizeof(TImageNtHeaders)) then
  begin
    ImageNTHeader:=PImageNtHeaders(ptrUint(header)+PImageDosHeader(header)^._lfanew);
    result:=ImageNTHeader.OptionalHeader.AddressOfEntryPoint;
  end;

end;

function peinfo_getheadersize(header: pointer): dword;
var
    ImageNTHeader: PImageNtHeaders;
begin
  if PImageDosHeader(header)^.e_magic<>IMAGE_DOS_SIGNATURE then
  begin
    result:=0;
    exit;
  end;

  ImageNTHeader:=PImageNtHeaders(ptrUint(header)+PImageDosHeader(header)^._lfanew);
  if ptrUint(ImageNTHeader)-ptrUint(header)>$1000 then exit;
  
  if ImageNTHeader.Signature<>IMAGE_NT_SIGNATURE then
  begin
    result:=0;
    exit;
  end;
  result:=ImageNTHeader.OptionalHeader.SizeOfHeaders;
end;

function peinfo_getimagesize(header: pointer): dword;
var
    ImageNTHeader: PImageNtHeaders;
begin
  ImageNTHeader:=PImageNtHeaders(ptrUint(header)+PImageDosHeader(header)^._lfanew);
  result:=ImageNTHeader.OptionalHeader.SizeOfImage;
end;

procedure TPEInfo.setModule(index : integer);
begin
  if (modules.Count > 0) and (index >= 0) and (index < modules.Count) then
    mod_addr:=inttohex(ptrUint(modules.Objects[index]),8);
end;

procedure TPEInfo.getPE();
var address: ptrUint;
    actualread: dword;
    headersize: dword;
    imagesize: dword;
    imagesizes: string;
    check: boolean;
begin
  try
    address:=StrToQWordEx('$'+mod_addr);
  except
    exit;
  end;

  if loadedmodule<>nil then
  begin
    virtualfree(loadedmodule,0,MEM_RELEASE	);
    loadedmodule:=nil;
  end;

  if memorycopy<>nil then
    freemem(memorycopy);

  getmem(memorycopy,4096);
  try
    if (not readprocessmemory(processhandle,pointer(address),memorycopy,4096,actualread)) or (actualread<>4096) then
      raise exception.Create('The header of the module could not be read');

    headersize:=peinfo_getheadersize(memorycopy);
    if headersize=0 then
      raise exception.Create('This is not a valid PE file');


    imagesize:=peinfo_getimagesize(memorycopy);

  finally
    freemem(memorycopy);

  end;


  if imagesize>256*1024*1024 then
  begin
    imagesizes:=inttostr(imagesize);
    if inputquery('PEInfo: Image size','The imagesize is more than 256 MB, is this the correct ammount? If not, edit here', imagesizes) then
    begin
      try
        imagesize:=strtoint(imagesizes);
      except
        exit;
      end;
    end
    else exit;
  end;
  getmem(memorycopy,imagesize);

  actualread:=0;
  check:=readprocessmemory(processhandle,pointer(address),memorycopy,imagesize,actualread);
  if actualread>0 then //work with this
  begin
    if not check then
      messagedlg('Not all memory could be read, working with a partial copy here',mtwarning,[mbok],0);

    memorycopysize:=actualread;
  end else exit;


  modulebase:=address;
  parsePE(true);
end;

procedure TPEInfo.parsePE(loaded: boolean);
var
    ImageImportDirectory : PImageImportDirectory;
    ImageImportAddress : PImageImportAddress;
    sFileType,sCharacteristics, sType: string;
    i, j, k: integer;
    exp_idx : integer;
    maxaddress: ptrUint;

    importaddress,a: PtrUInt;
    b : PDWord;
    importfunctionname: string;
    importmodulename: string;
    //ignore: dword;
    //correctprotection: dword;

    basedifference: ptrUint;
    basedifference64: INT64;

    modhandle: thandle;
    funcaddress: ptrUint;

    numberofrva: integer;

    tempaddress,tempaddress2: ptrUint;

    tempstring: pchar;
    mod_ : THandle;
    ulSize: PULONG;
begin
  try
    is64bit:=false;
    ImageDosHeader:=PImageDosHeader(memorycopy);
    if ImageDosHeader.e_magic<>IMAGE_DOS_SIGNATURE then
      raise exception.Create(rsThisIsNotAValidImage);

    ImageNtHeader:=peinfo_getImageNtHeaders(memorycopy, memorycopysize);
    if ImageNtHeader=nil then exit;

    if ImageNTHeader.FileHeader.Machine=$8664 then
      is64bit:=true;


    sFileType:='';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_EXECUTABLE_IMAGE = IMAGE_FILE_EXECUTABLE_IMAGE then sFileType:=sFiletype+'Executable, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_RELOCS_STRIPPED = IMAGE_FILE_RELOCS_STRIPPED then sFileType:=sFiletype+'No relocations, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_LINE_NUMS_STRIPPED = IMAGE_FILE_LINE_NUMS_STRIPPED then sFileType:=sFiletype+'No line numbers, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_LOCAL_SYMS_STRIPPED = IMAGE_FILE_LOCAL_SYMS_STRIPPED then sFileType:=sFiletype+'No local symbols, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_AGGRESIVE_WS_TRIM = IMAGE_FILE_AGGRESIVE_WS_TRIM then sFileType:=sFiletype+'Agressive trim, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_BYTES_REVERSED_LO = IMAGE_FILE_BYTES_REVERSED_LO then sFileType:=sFiletype+'Reversed bytes LO, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_32BIT_MACHINE = IMAGE_FILE_32BIT_MACHINE then sFileType:=sFiletype+'32-bit, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_DEBUG_STRIPPED = IMAGE_FILE_DEBUG_STRIPPED then sFileType:=sFiletype+'No DBG info, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP = IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP then sFileType:=sFiletype+'Removable: Run from swap, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_NET_RUN_FROM_SWAP = IMAGE_FILE_NET_RUN_FROM_SWAP then sFileType:=sFiletype+'Net: Run from swap, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_SYSTEM = IMAGE_FILE_SYSTEM then sFileType:=sFiletype+'System file, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_DLL = IMAGE_FILE_DLL then sFileType:=sFiletype+'DLL, ';
    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_UP_SYSTEM_ONLY = IMAGE_FILE_UP_SYSTEM_ONLY then sFileType:=sFiletype+'UP system only, ';

    if ImageNTHeader.FileHeader.Characteristics and IMAGE_FILE_BYTES_REVERSED_HI = IMAGE_FILE_BYTES_REVERSED_HI then sFileType:=sFiletype+'Reversed bytes HI, ';


    sFileType:=copy(sfiletype,1,length(sfiletype)-2);
    if sFileType='' then
      sFileType:='Unknown';

    if is64bit then
    begin
      numberofrva:=PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.NumberOfRvaAndSizes;
    end
    else
    begin
      numberofrva:=ImageNTHeader^.OptionalHeader.NumberOfRvaAndSizes;
    end;

    ImageSectionHeader:=PImageSectionHeader(ptrUint(@ImageNTHeader^.OptionalHeader)+ImageNTHeader^.FileHeader.SizeOfOptionalHeader);
    maxaddress:=0;


    for i:=0 to ImageNTHeader.FileHeader.NumberOfSections-1 do
    begin
      sCharacteristics:='';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_CNT_CODE = IMAGE_SCN_CNT_CODE then sCharacteristics:='Executable code, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_CNT_INITIALIZED_DATA = IMAGE_SCN_CNT_INITIALIZED_DATA then sCharacteristics:=sCharacteristics+'Initialized data, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_CNT_UNINITIALIZED_DATA = IMAGE_SCN_CNT_UNINITIALIZED_DATA then sCharacteristics:=sCharacteristics+'Uninitialized data, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_LNK_REMOVE = IMAGE_SCN_LNK_REMOVE then sCharacteristics:=sCharacteristics+'removed, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_DISCARDABLE = IMAGE_SCN_MEM_DISCARDABLE then sCharacteristics:=sCharacteristics+'discardable, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_NOT_CACHED = IMAGE_SCN_MEM_NOT_CACHED then sCharacteristics:=sCharacteristics+'not cached, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_NOT_PAGED = IMAGE_SCN_MEM_NOT_PAGED then sCharacteristics:=sCharacteristics+'not paged, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_SHARED = IMAGE_SCN_MEM_SHARED then sCharacteristics:=sCharacteristics+'shared memory, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_EXECUTE = IMAGE_SCN_MEM_EXECUTE then sCharacteristics:=sCharacteristics+'executable memory, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_READ = IMAGE_SCN_MEM_READ then sCharacteristics:=sCharacteristics+'readable memory, ';
      if ImageSectionHeader.Characteristics and IMAGE_SCN_MEM_WRITE = IMAGE_SCN_MEM_WRITE then sCharacteristics:=sCharacteristics+'writable memory, ';

      sCharacteristics:=copy(sCharacteristics,1,length(sCharacteristics)-2);

      if sCharacteristics='' then sCharacteristics:='Unknown';

      if maxaddress<(ImageSectionHeader.VirtualAddress+ImageSectionHeader.SizeOfRawData) then
        maxaddress:=ImageSectionHeader.VirtualAddress+ImageSectionHeader.SizeOfRawData;

      inc(ImageSectionHeader);
    end;

    ImageSectionHeader:=PImageSectionHeader(ptrUint(@ImageNTHeader^.OptionalHeader)+ImageNTHeader^.FileHeader.SizeOfOptionalHeader);

    if loaded then
    begin
      loadedmodule:=memorycopy;

      if is64bit then
      begin
        basedifference:=ptrUint(loadedmodule)-PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.ImageBase;
        basedifference64:=UINT64(ptrUint(loadedmodule))-PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.ImageBase;
      end
      else
      begin
        basedifference:=ptrUint(loadedmodule)-ImageNTHeader^.OptionalHeader.ImageBase;
      end;
    end
    else
    begin
      //from a file
      loadedmodule:=virtualalloc(nil,maxaddress, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      if loadedmodule=nil then raise exception.create('Failure at allocating memory');
      ZeroMemory(loadedmodule,maxaddress);

      for i:=0 to ImageNTHeader.FileHeader.NumberOfSections-1 do
      begin
        CopyMemory(@loadedmodule[ImageSectionHeader.VirtualAddress], @memorycopy[ImageSectionHeader.PointerToRawData], ImageSectionHeader.SizeOfRawData);
        inc(ImageSectionHeader);
      end;

      if is64bit then
      begin
        CopyMemory(@loadedmodule[0], @memorycopy[0], PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.SizeOfHeaders);

        basedifference:=ptrUint(loadedmodule)-PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.ImageBase;
        basedifference64:=UINT64(ptrUint(loadedmodule))-PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.ImageBase;
      end
      else
      begin
        CopyMemory(@loadedmodule[0], @memorycopy[0], ImageNTHeader^.OptionalHeader.SizeOfHeaders);
        basedifference:=ptrUint(loadedmodule)-ImageNTHeader^.OptionalHeader.ImageBase;

      end;

    end;

    //now it has been mapped the vla and other stuff can be handled
    exp_idx := 0;
    for i:=0 to numberofrva-1 do
    begin
      case i of
        0: sType:='Export table';
        1: sType:='Import table';
        2: sType:='Resource table';
        3: sType:='Exception table';
        4: sType:='Certificate table';
        5: sType:='Base-Relocation table';
        6: sType:='Debugging info table';
        7: sType:='Architecture-Specific table';
        8: sType:='Global pointer table';
        9: sType:='TLS table';
       10: sType:='Load config table';
       11: sType:='Bound import table';
       12: sType:='import address table';
       13: sType:='Delay import descriptor table';
       else sType:='reserved';
      end;

      if (is64bit and (PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.DataDirectory[i].VirtualAddress=0)) or
         ((not is64bit) and (ImageNTHeader^.OptionalHeader.DataDirectory[i].VirtualAddress=0)) then
        continue; //don't look into it

      if i=1 then
      begin  //import
             //mod_ := symhandler.;
             //ImageImportDirectory := ImageDirectoryEntryToData(Pointer(mod_), TRUE, IMAGE_DIRECTORY_ENTRY_IMPORT, &ulSize);
             //
        j:=0;
        if is64bit then
          ImageImportDirectory:=PImageImportDirectory(ptrUint(loadedmodule)+PImageOptionalHeader64(@ImageNTHeader^.OptionalHeader)^.DataDirectory[i].VirtualAddress)
        else
          ImageImportDirectory:=PImageImportDirectory(ptrUint(loadedmodule)+ImageNTHeader^.OptionalHeader.DataDirectory[i].VirtualAddress);

        while (j<45) do
        begin
          if ImageImportDirectory.name=0 then break;

          importmodulename:=pchar(ptrUint(loadedmodule)+ImageImportDirectory.name);

          if ImageImportDirectory.ForwarderChain<>$ffffffff then
          begin
            if not loaded then
              modhandle:=loadlibrary(pchar(importmodulename));

            k:=0;
            if is64bit then
            begin
              while PUINT64(ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk+8*k)^<>0 do
              begin
                importaddress:=ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk+8*k;
                a := ptrUint(loadedmodule);
                b := pdword(importaddress);
                importfunctionname:=pchar(a+b^+2);

                if not loaded then
                begin
                  funcaddress:=ptrUint(getprocaddress(modhandle, pchar(importfunctionname)));
                  PUINT64(importaddress)^:=funcaddress;
                end;
                inc(k);
              end;
            end
            else
            begin
              while PDWORD(ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk+4*k)^<>0 do
              begin
                importaddress:=ptrUint(@pdwordarray(ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk)[k]);

                tempaddress:=ptrUint(loadedmodule)+pdwordarray(ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk)[k]+2;
                if loaded then
                begin
                  //lookup
                  tempaddress2:=pdwordarray(ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk)[k];
                  importfunctionname:=symhandler.getNameFromAddress(tempaddress2);

                  if uppercase(inttohex(tempaddress2,8))=uppercase(importfunctionname) then
                  begin
                    //failure to convert the address to an import
                    inc(k);
                    continue;
                  end;
                end
                else
                begin
                  //get the name from the file
                  if InRangeX(tempaddress, ptruint(loadedmodule), ptruint(loadedmodule)+memorycopysize-100) then
                  begin
                    setlength(importfunctionname, 100);
                    CopyMemory(@importfunctionname[1], pointer(tempaddress), 99);
                    importfunctionname[99]:=#0;
                  end
                  else
                    importfunctionname:='err';

                end;
                New(ImageImportAddress);
                ImageImportAddress.xxx:=importaddress-ptrUint(loadedmodule)+ImageNTHeader.OptionalHeader.ImageBase;
                ImageImportAddress.addr:=pdwordarray(ptrUint(loadedmodule)+ImageImportDirectory.FirstThunk)[k];
                ImageImportAddress.name:=importfunctionname;
                ImageImportAddresses.Add(ImageImportAddress);
                if not loaded then
                begin
                  funcaddress:=ptrUint(getprocaddress(modhandle, pchar(importfunctionname)));
                  pdword(importaddress)^:=funcaddress;
                end;

                inc(k);
              end;
            end;
          end;

          inc(j);
          ImageImportDirectory:=PImageImportDirectory(ptrUint(ImageImportDirectory)+sizeof(TImageImportDirectory));
        end;
      end;
    end;

  finally
  end;


  if loaded then
  begin
    loadedmodule:=nil;
  end
  else
  begin
    if (loadedmodule<>nil) then
    begin
      virtualfree(loadedmodule,0,MEM_RELEASE);
      loadedmodule:=nil;
    end;
  end;
end;

constructor TPEInfo.Create(moduleList : TStrings);
begin
     modules := TStringList.Create;
     modules.Clear;
     modules := moduleList;
     if modules.Count>0 then
     begin
          setModule(0);
      end;
     ImageImportAddresses := TList.Create;
end;

destructor TPEInfo.Destroy();
begin
  if memorycopy<>nil then
    freemem(memorycopy);
  if loadedmodule<>nil then
    VirtualFree(loadedmodule,0,MEM_RELEASE);
  ImageImportAddresses.Free;
end;

end.






