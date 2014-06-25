unit scanner;

{$mode objfpc}{$H+}

interface

uses
  Classes,memscan, foundlisthelper, windows, dialogs;

const
  foundlistDisplayOverride = 0;

type TOnScanDoneCallback = procedure ();

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
  TScanner = class(TObject)
  public
    state : PScanState;
    scandone : TOnScanDoneCallback;
    procedure addScanner();
  private
    procedure SetupInitialScanTabState(scanstate: PScanState;
    IsFirstEntry: boolean);
    procedure OnScanDone(Sender: TObject);
    end;

implementation

procedure TScanner.addScanner();
var
   newstate: PScanState;
begin
   getmem(newstate, sizeof(TScanState));
   SetupInitialScanTabState(newstate, True);
   Self.state := newstate;
   Self.state^.memscan.OnScanDone := @OnScanDone;
end;

procedure TScanner.SetupInitialScanTabState(scanstate: PScanState;
  IsFirstEntry: boolean);
begin
  ZeroMemory(scanstate, sizeof(TScanState));
  scanstate^.memscan := tmemscan.Create(nil);
  scanstate^.foundlist := TFoundList.Create(nil, scanstate^.memscan);    //build again
    //scanstate^.memscan.setScanDoneCallback(fmCE.handle, wm_scandone);

  //initial scans don't have a previous scan
  scanstate^.lblcompareToSavedScan.Visible := False;
  scanstate^.compareToSavedScan := False;

end;

procedure TScanner.OnScanDone(Sender : TObject);
begin
  showmessage('ok');
  scandone();
end;

end.

