unit scanner;

{$MODE Delphi}

interface

uses
  Classes,memscan, foundlisthelper, windows, CEFuncProc,dialogs,SysUtils,ComCtrls;

const
  foundlistDisplayOverride = 0;
  wm_scandone = WM_APP + 2;

type
TScanState = record
  alignsizechangedbyuser: boolean;
  compareToSavedScan: boolean;
  currentlySelectedSavedResultname: string; //I love long variable names

  lblcompareToSavedScan: record
    Caption: string;
    Visible: boolean;
    left: integer;
  end;


  FromAddress: record
    Text: string;
  end;

  ToAddress: record
    Text: string;
  end;

  cbReadOnly: record
    Checked: boolean;
  end;

  cbfastscan: record
    Checked: boolean;
  end;

  cbunicode: record
    checked: boolean;
    visible: boolean;
  end;

  cbCaseSensitive: record
    checked: boolean;
    visible: boolean;
  end;

  edtAlignment: record
    Text: string;
  end;


  cbpercentage: record
    exists: boolean;
    Checked: boolean;
  end;


  floatpanel: record
    Visible: boolean;
    rounded: boolean;
    roundedextreme: boolean;
    truncated: boolean;
  end;

  rbbit: record
    Visible: boolean;
    Enabled: boolean;
    Checked: boolean;
  end;

  rbdec: record
    Visible: boolean;
    Enabled: boolean;
    Checked: boolean;
  end;

  cbHexadecimal: record
    Visible: boolean;
    Checked: boolean;
    Enabled: boolean;
  end;

  gbScanOptionsEnabled: boolean;

  scantype: record
    options: string;
    ItemIndex: integer;
    Enabled: boolean;
    dropdowncount: integer;
  end;

  vartype: record
    //options: TStringList;
    ItemIndex: integer;
    Enabled: boolean;
  end;


  memscan: TMemscan;
  foundlist: TFoundList;


  scanvalue: record
    Visible: boolean;
    Text: string;
  end;

  scanvalue2: record
    exists: boolean;
    Text: string;
  end;

  firstscanstate: record
    Caption: string;
    Enabled: boolean;
  end;

  nextscanstate: record
    Enabled: boolean;
  end;

  button2: record
    tag: integer;
  end;

  foundlist3: record
    ItemIndex: integer;
  end;
  foundlistDisplayOverride: integer;

end;
PScanState = ^TScanState;

  type
  TIScanner = class(TObject)
  public
    foundlist : TFoundList;
    memscan : Tmemscan;
    hwnd : THandle;
    constructor Create(hwnd : THandle);
    constructor Create(hwnd : THandle ; list : TListView); overload;
    destructor Destroy();
  private
    state : PScanState;
    procedure addScanner();
    procedure SetupInitialScanTabState(scanstate: PScanState;
    IsFirstEntry: boolean);
    end;

implementation

procedure TIScanner.addScanner();
var
   newstate: PScanState;
begin
   getmem(newstate, sizeof(TScanState));
   SetupInitialScanTabState(newstate, True);
   Self.state := newstate;
end;

procedure TIScanner.SetupInitialScanTabState(scanstate: PScanState;
  IsFirstEntry: boolean);
begin
  ZeroMemory(scanstate, sizeof(TScanState));

  if IsFirstEntry then
  begin
    scanstate.memscan := memscan;
    scanstate.foundlist := foundlist;
  end
  else
  begin
    scanstate.memscan := tmemscan.Create(nil);
    scanstate.foundlist := TFoundList.Create(nil, scanstate^.memscan);    //build again
  end;
  scanstate.memscan.setScanDoneCallback(hwnd, WM_SCANDONE);
  //initial scans don't have a previous scan
  scanstate.lblcompareToSavedScan.Visible := False;
  scanstate.compareToSavedScan := False;
end;

constructor TIScanner.Create(hwnd : THandle);
begin
  self.hwnd:=hwnd;
  memscan := Tmemscan.create(nil);
  foundlist := TFoundList.create(nil,memscan);
  addScanner();
end;

constructor TIScanner.Create(hwnd : THandle ; list : TListView); overload;
begin
  self.hwnd:=hwnd;
  memscan := Tmemscan.create(nil);
  foundlist := TFoundList.create(list,memscan);
  addScanner();
end;

destructor TIScanner.Destroy();
begin
  foundlist.Free;
  memscan.Free;
end;

end.

