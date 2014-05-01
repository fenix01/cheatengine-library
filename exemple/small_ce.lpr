program small_ce;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main, Assemblerunit, autoassembler, byteinterpreter, CEFuncProc,
  CustomTypeHandler, cvconst, fileaccess, Filehandler, hypermode, ProcessHandlerUnit, savedscanhandler, symbolhandler,
  SymbolListHandler, PEInfoFunctions, FileMapping, PEInfounit,
  MemoryRecordUnit, hotkeyhandler, genericHotkey, MemoryRecordDatabase;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfmCE, fmCE);
  Application.Run;
end.

