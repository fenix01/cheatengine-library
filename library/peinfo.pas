unit PEInfo;

{$mode objfpc}{$H+}

interface

uses
    windows, LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CEFuncProc, NewKernelHandler, Buttons, StdCtrls, ExtCtrls,
  ComCtrls, LResources, symbolhandler, PEInfoFunctions;


function peinfo_getcodesize(header: pointer; headersize: integer=0): dword;
function peinfo_getentryPoint(header: pointer; headersize: integer=0): ptrUint;
function peinfo_getcodebase(header: pointer; headersize: integer=0): ptrUint;
function peinfo_getdatabase(header: pointer; headersize: integer=0): ptrUint;
function peinfo_getheadersize(header: pointer): dword;

var
   memorycopy: pbytearray;
   memorycopysize: dword;
   modulebase: dword;

   loadedmodule: pbytearray;

implementation

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

procedure parsePE(addr : string);
var address: ptrUint;
    actualread: dword;
    headersize: dword;
    imagesize: dword;
    imagesizes: string;
    check: boolean;
begin
  try
    address:=StrToQWordEx('$'+addr);
  except
    exit;
  end;

  if loadedmodule<>nil then
  begin
    virtualfree(loadedmodule,0,MEM_RELEASE);
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
  end else raise exception.Create('Failure reading memory');
  modulebase:=address;
end;

end.

