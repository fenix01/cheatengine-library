unit AddressChangeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, symbolhandler, byteinterpreter, CEFuncProc;

procedure IProcessAddress(address : WideString ; vartype : TVariableType ; showashexadecimal: Boolean=false;
  showAsSigned: boolean=false; bytesize: Integer = 1; out res_address : WideString = '');stdcall;

implementation

procedure IProcessAddress(address : WideString ; vartype : TVariableType ; showashexadecimal: Boolean=false;
  showAsSigned: boolean=false; bytesize: Integer = 1; out res_address : WideString = '');stdcall;
var a: PtrUInt;
  e: boolean;
begin
  //read the address and display the value it points to

  a:=symhandler.getAddressFromName(utf8toansi(address),false,e);
  if not e then
  begin
    //get the vartype and parse it
    res_address:=readAndParseAddress(a, vartype,nil,showashexadecimal, showAsSigned, bytesize);
  end
  else
    res_address:='???';
end;

end.

