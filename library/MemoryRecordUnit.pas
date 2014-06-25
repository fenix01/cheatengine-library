unit MemoryRecordUnit;

{$mode DELPHI}

interface

uses
  Windows, forms, graphics, Classes, SysUtils, controls, stdctrls, comctrls,symbolhandler,
  cefuncproc,newkernelhandler, autoassembler, hotkeyhandler, dom, XMLRead,XMLWrite,
  customtypehandler, fileutil, LCLProc;

type TMemrecHotkeyAction=(mrhToggleActivation, mrhToggleActivationAllowIncrease, mrhToggleActivationAllowDecrease, mrhActivate, mrhDeactivate, mrhSetValue, mrhIncreaseValue, mrhDecreaseValue);

type TFreezeType=(ftFrozen, ftAllowIncrease, ftAllowDecrease);



type TMemrecOption=(moHideChildren, moBindActivation, moRecursiveSetValue, moAllowManualCollapseAndExpand);
type TMemrecOptions=set of TMemrecOption;

type TMemrecStringData=record
  unicode: boolean;
  length: integer;
  ZeroTerminate: boolean;
end;

type TMemRecBitData=record
      Bit     : Byte;
      bitlength: integer;
      showasbinary: boolean;
    end;

type TMemRecByteData=record
      bytelength: integer;
    end;

type TMemRecAutoAssemblerData=record
      script: tstringlist;
      allocs: TCEAllocArray;
      registeredsymbols: TStringlist;
    end;

type TMemRecExtraData=record
    case integer of
      1: (stringData: TMemrecStringData); //if this is the last level (maxlevel) this is an PPointerList
      2: (bitData: TMemRecBitData);   //else it's a PReversePointerListArray
      3: (byteData: TMemRecByteData);
  end;




type
  TMemoryRecordActivateEvent=function (sender: TObject; before, currentstate: boolean): boolean of object;
  TMemoryRecordHotkey=class;
  TMemoryRecord=class
  private
    fID: integer;
    FrozenValue : string;
    CurrentValue: string;
    UndoValue   : string;  //keeps the last value before a manual edit


    UnreadablePointer: boolean;
    BaseAddress: ptrUint; //Base address
    RealAddress: ptrUint; //If pointer, or offset the real address
    fIsOffset: boolean;
    fOwner : TObject;

    fShowAsSignedOverride: boolean;
    fShowAsSigned: boolean;

    fActive: boolean;
    fAllowDecrease: boolean;
    fAllowIncrease: boolean;

    fShowAsHex: boolean;
    editcount: integer; //=0 when not being edited

    fOptions: TMemrecOptions;

    CustomType: TCustomType;
    fCustomTypeName: string;
    fColor: TColor;
    fVisible: boolean;

    fVarType : TVariableType;

    couldnotinterpretaddress: boolean; //set when the address interpetation has failed since last eval

    hknameindex: integer;

    Hotkeylist: tlist;


    fonactivate, fondeactivate: TMemoryRecordActivateEvent;
    fOnDestroy: TNotifyEvent;
    function getByteSize: integer;
    function BinaryToString(b: pbytearray; bufsize: integer): string;
    function getAddressString: string;
    function getuniquehotkeyid: integer;
    procedure setActive(state: boolean);
    procedure setAllowDecrease(state: boolean);
    procedure setAllowIncrease(state: boolean);
    procedure setVisible(state: boolean);
    procedure setShowAsHex(state: boolean);
    procedure setOptions(newOptions: TMemrecOptions);
    procedure setCustomTypeName(name: string);
    procedure setColor(c: TColor);
    procedure setVarType(v:  TVariableType);
    function getHotkeyCount: integer;
    function getHotkey(index: integer): TMemoryRecordHotkey;
    function GetshowAsSigned: boolean;
    procedure setShowAsSigned(state: boolean);




    procedure setID(i: integer);
  public




    Description : string;
    interpretableaddress: string;


    pointeroffsets: array of integer; //if set this is an pointer



    Extra: TMemRecExtraData;
    AutoAssemblerData: TMemRecAutoAssemblerData;



    isSelected: boolean; //lazarus bypass. Because lazarus does not implement multiselect I have to keep track of which entries are selected

    showAsHex: boolean;

    //free for editing by user:
    autoAssembleWindow: TForm; //window storage for an auto assembler editor window


    function isBeingEdited: boolean;
    procedure beginEdit;
    procedure endEdit;

    function isPointer: boolean;
    function isOffset: boolean;
    procedure ApplyFreeze;

    function GetValue: string;
    procedure SetValue(v: string); overload;
    procedure SetValue(v: string; isFreezer: boolean); overload;
    procedure UndoSetValue;
    function canUndo: boolean;
    procedure increaseValue(value: string);
    procedure decreaseValue(value: string);
    function GetRealAddress: PtrUInt;
    function getBaseAddress: ptrUint; //return the base address, if offset, the calculated address
    procedure RefreshCustomType;
    function ReinterpretAddress(forceremovalofoldaddress: boolean=false): boolean;
    property Value: string read GetValue write SetValue;
    property bytesize: integer read getByteSize;

    function hasHotkeys: boolean;
    function Addhotkey(keys: tkeycombo; action: TMemrecHotkeyAction; value, description: string): TMemoryRecordHotkey;
    function removeHotkey(hk: TMemoryRecordHotkey): boolean;

    procedure DoHotkey(hk :TMemoryRecordHotkey); //execute the specific hotkey action

    procedure disablewithoutexecute;

    constructor Create(AOwner : TObject);
    destructor destroy; override;


    property HotkeyCount: integer read getHotkeyCount;
    property Hotkey[index: integer]: TMemoryRecordHotkey read getHotkey;

    property visible: boolean read fVisible write setVisible;

  published
    property ID: integer read fID write setID;
    property Color: TColor read fColor write setColor;
    property AddressString: string read getAddressString;
    property Active: boolean read fActive write setActive;
    property VarType: TVariableType read fVarType write setVarType;
    property CustomTypeName: string read fCustomTypeName write setCustomTypeName;
    property Value: string read GetValue write SetValue;
    property AllowDecrease: boolean read fallowDecrease write setAllowDecrease;
    property AllowIncrease: boolean read fallowIncrease write setAllowIncrease;
    property ShowAsHex: boolean read fShowAsHex write setShowAsHex;
    property ShowAsSigned: boolean read getShowAsSigned write setShowAsSigned;
    property Options: TMemrecOptions read fOptions write setOptions;
    property CustomTypeName: string read fCustomTypeName write setCustomTypeName;
    property OnActivate: TMemoryRecordActivateEvent read fOnActivate write fOnActivate;
    property OnDeactivate: TMemoryRecordActivateEvent read fOnDeActivate write fOndeactivate;
    property OnDestroy: TNotifyEvent read fOnDestroy write fOnDestroy;

  end;

  TMemoryRecordHotkey=class
  private
    fOnHotkey: TNotifyevent;
    fOnPostHotkey: TNotifyevent;
  public
    fID: integer;
    fKeyOwner : HWND;
    fDescription: string;
    fOwner: TMemoryRecord;
    keys: Tkeycombo;
    action: TMemrecHotkeyAction;
    value: string;

    procedure doHotkey;
    constructor create(AnOwner: TMemoryRecord);
    destructor destroy; override;
  published
    property KeyOwner : HWND read fKeyOWner write fKeyOWner;
    property Description: string read fDescription;
    property Owner: TMemoryRecord read fOwner;
    property ID: integer read fID;
    property OnHotkey: TNotifyEvent read fOnHotkey write fOnHotkey;
    property OnPostHotkey: TNotifyEvent read fOnPostHotkey write fOnPostHotkey;
  end;


function MemRecHotkeyActionToText(action: TMemrecHotkeyAction): string;
function TextToMemRecHotkeyAction(text: string): TMemrecHotkeyAction;

implementation

uses MemoryRecordDatabase;

{-----------------------------TMemoryRecordHotkey------------------------------}
constructor TMemoryRecordHotkey.create(AnOwner: TMemoryRecord);
begin
  //add to the hotkeylist
  fid:=-1;
  fowner:=AnOwner;
  fowner.hotkeylist.Add(self);

  keys[0]:=0;

  RegisterHotKey2(KeyOwner, 0, keys, self);
end;

destructor TMemoryRecordHotkey.destroy;
begin
  UnregisterAddressHotkey(self);

  //remove this hotkey from the memoryrecord
  if owner<>nil then
    owner.hotkeylist.Remove(self);
end;

procedure TMemoryRecordHotkey.doHotkey;
begin
  if assigned(fonhotkey) then
    fOnHotkey(self);

  if owner<>nil then //just be safe (e.g other app sending message)
    owner.DoHotkey(self);

  if assigned(fonPostHotkey) then
    fOnPostHotkey(self);
end;

{---------------------------------MemoryRecord---------------------------------}


function TMemoryRecord.getHotkeyCount: integer;
begin
  result:=hotkeylist.count;
end;

function TMemoryRecord.getHotkey(index: integer): TMemoryRecordHotkey;
begin
  result:=nil;

  if index<hotkeylist.count then
    result:=TMemoryRecordHotkey(hotkeylist[index]);
end;

constructor TMemoryRecord.Create(AOwner : TObject);
begin
  fVisible:=true;
  fid:=-1;
  fColor:=clWindowText;
  fOwner := AOwner;
  hotkeylist:=tlist.create;

  foptions:=[];

  inherited create;
end;

destructor TMemoryRecord.Destroy;
var i: integer;
begin
  if assigned(fOnDestroy) then
    fOnDestroy(self);

  //unregister hotkeys
  if hotkeylist<>nil then
  begin
    while hotkeylist.count>0 do
      TMemoryRecordHotkey(hotkeylist[0]).free;

    hotkeylist.free;
  end;

  //free script space
  if autoassemblerdata.script<>nil then
    autoassemblerdata.script.free;

  //free script info
  if autoassemblerdata.registeredsymbols<>nil then
    autoassemblerdata.registeredsymbols.free;


  inherited Destroy;

end;

procedure TMemoryRecord.setOptions(newOptions: TMemrecOptions);
begin
  foptions:=newOptions;
  //apply changes (moHideChildren, moBindActivation, moRecursiveSetValue)
end;

procedure TMemoryRecord.setCustomTypeName(name: string);
begin
  fCustomTypeName:=name;
  RefreshCustomType;
end;

procedure TMemoryRecord.setVarType(v:  TVariableType);
begin
  //setup some of the default settings
  case v of
    vtUnicodeString: //this type was added later. convert it to a string
    begin
      fvartype:=vtString;
      extra.stringData.unicode:=true;
      extra.stringData.ZeroTerminate:=true;
    end;

    vtPointer:  //also added later. In this case show as a hex value
    begin
      if processhandler.is64bit then
        fvartype:=vtQword
      else
        fvartype:=vtDword;

      showAsHex:=true;
    end;


    vtString: //if setting to the type of string enable the zero terminate method by default
      extra.stringData.ZeroTerminate:=true;

    vtAutoAssembler:
      if AutoAssemblerData.script=nil then
        AutoAssemblerData.script:=tstringlist.create;
  end;



  fVarType:=v;
end;

procedure TMemoryRecord.setColor(c: TColor);
begin
  fColor:=c;
  //TAddresslist(fOwner).Update;
end;

procedure TMemoryRecord.setShowAsSigned(state: boolean);
begin
  fShowAsSignedOverride:=true;
  fShowAsSigned:=state;
end;

function TMemoryRecord.GetShowAsSigned: boolean;
begin
  if fShowAsSignedOverride then
    result:=fShowAsSigned
  else
    result:=true;
end;

function TMemoryRecord.isBeingEdited: boolean;
begin
  result:=editcount>0;
end;

procedure TMemoryRecord.beginEdit;
begin
  inc(editcount);
end;

procedure TMemoryRecord.endEdit;
begin
  dec(editcount);
end;

function TMemoryRecord.isPointer: boolean;
begin
  result:=length(pointeroffsets)>0;
end;

function TMemoryRecord.isOffset: boolean;
begin
  result:=fIsOffset;
end;

function TMemoryRecord.hasHotkeys: boolean;
begin
  result:=HotkeyCount>0;
end;

function TMemoryRecord.removeHotkey(hk: TMemoryRecordHotkey): boolean;
begin
  hk.free;
  result:=true;
end;

procedure TMemoryRecord.setID(i: integer);
var a: TMemoryRecordTable;

begin
  if i<>fid then
  begin
    //new id, check fo duplicates (e.g copy/paste)
    a:=TMemoryRecordTable(fOwner);

    if a.getRecordWithID(i)<>nil then
      fid:=a.GetUniqueMemrecId
    else
      fid:=i;
  end;
end;

function TMemoryRecord.getuniquehotkeyid: integer;
//goes through the hotkeylist and returns an unused id
var i: integer;
  isunique: boolean;
begin
  result:=0;
  for result:=0 to maxint-1 do
  begin
    isunique:=true;
    for i:=0 to hotkeycount-1 do
      if hotkey[i].id=result then
      begin
        isunique:=false;
        break;
      end;

    if isunique then break;
  end;
end;

function TMemoryRecord.Addhotkey(keys: tkeycombo; action: TMemrecHotkeyAction; value, description: string): TMemoryRecordHotkey;
{
adds and registers a hotkey and returns the hotkey index for this hotkey
return -1 if failure
}
var
  hk: TMemoryRecordHotkey;
begin
  hk:=TMemoryRecordHotkey.create(self);

  hk.fid:=getuniquehotkeyid;
  hk.keys:=keys;
  hk.action:=action;
  hk.value:=value;
  hk.fdescription:=description;

  result:=hk;
end;

procedure TMemoryRecord.increaseValue(value: string);
var
  oldvalue: qword;
  oldvaluedouble: double;
  increasevalue: qword;
  increasevaluedouble: double;
begin
  if VarType in [vtByte, vtWord, vtDword, vtQword, vtSingle, vtDouble, vtCustom] then
  begin
    try
      if showAsHex then //seperate handler for hexadecimal. (handle as int, even for the float types)
      begin
        oldvalue:=StrToQWordEx('$'+getvalue);
        increasevalue:=StrToQwordEx('$'+value);
        setvalue(IntTohex(oldvalue+increasevalue,1));
      end
      else
      begin
        if VarType in [vtByte, vtWord, vtDword, vtQword, vtCustom] then
        begin
          oldvalue:=StrToQWordEx(getvalue);
          increasevalue:=StrToQWordEx(value);
          setvalue(IntToStr(oldvalue+increasevalue));
        end
        else
        begin
          oldvaluedouble:=StrToFloat(getValue);
          increasevalueDouble:=StrToFloat(value);
          setvalue(FloatToStr(oldvaluedouble+increasevalueDouble));
        end;
      end;
    except

    end;
  end;
end;

procedure TMemoryRecord.decreaseValue(value: string);
var
  oldvalue: qword;
  oldvaluedouble: double;
  decreasevalue: qword;
  decreasevaluedouble: double;
begin
  if VarType in [vtByte, vtWord, vtDword, vtQword, vtSingle, vtDouble] then
  begin
    try
      if VarType in [vtByte, vtWord, vtDword, vtQword] then
      begin
        oldvalue:=StrToQWordEx(getvalue);
        decreasevalue:=StrToQWordEx(value);
        setvalue(IntToStr(oldvalue-decreasevalue));
      end
      else
      begin
        oldvaluedouble:=StrToFloat(getValue);
        decreasevalueDouble:=StrToFloat(value);
        setvalue(FloatToStr(oldvaluedouble-decreasevalueDouble));
      end;
    except

    end;
  end;
end;

procedure TMemoryRecord.disablewithoutexecute;
begin
  factive:=false;
end;

procedure TMemoryRecord.DoHotkey(hk: TMemoryRecordhotkey);
begin
  if (hk<>nil) and (hk.owner=self) then
  begin
    try
      case hk.action of
        mrhToggleActivation: active:=not active;
        mrhSetValue:         SetValue(hk.value);
        mrhIncreaseValue:    increaseValue(hk.value);
        mrhDecreaseValue:    decreaseValue(hk.value);


        mrhToggleActivationAllowDecrease:
        begin
          allowDecrease:=True;
          active:=not active;
        end;

        mrhToggleActivationAllowIncrease:
        begin
          allowIncrease:=True;
          active:=not active;
        end;

        mrhActivate: active:=true;
        mrhDeactivate: active:=false;


      end;
    except
      //don't complain about incorrect values
    end;
  end;
end;

procedure TMemoryRecord.setAllowDecrease(state: boolean);
begin
  fAllowDecrease:=state;
  if state then
    fAllowIncrease:=false; //at least one of the 2 must always be false
end;

procedure TMemoryRecord.setAllowIncrease(state: boolean);
begin
  fAllowIncrease:=state;
  if state then
    fAllowDecrease:=false; //at least one of the 2 must always be false
end;

procedure TMemoryRecord.setActive(state: boolean);
var f: string;
    i: integer;
begin
  //6.0 compatibility
  if state=fActive then exit; //no need to execute this is it's the same state

  //6.1+
  if state then
  begin
    //activating , before
    if assigned(fonactivate) then
      if not fonactivate(self, true, fActive) then exit; //do not activate if it returns false
  end
  else
  begin
    if assigned(fondeactivate) then
      if not fondeactivate(self, true, fActive) then exit;
  end;

    if self.VarType = vtAutoAssembler then
    begin
      //aa script
      try
        if autoassemblerdata.registeredsymbols=nil then
          autoassemblerdata.registeredsymbols:=tstringlist.create;

        if autoassemble(autoassemblerdata.script, false, state, false, false, autoassemblerdata.allocs, autoassemblerdata.registeredsymbols) then
        begin
          fActive:=state;
          if autoassemblerdata.registeredsymbols.Count>0 then //if it has a registered symbol then reinterpret all addresses
            TMemoryRecordTable(fOwner).ReinterpretAddresses;
        end;
      except
        //running the script failed, state unchanged
      end;

    end
    else
    begin
      //freeze/unfreeze
      if state then
      begin
        f:=GetValue;

        try
          SetValue(f);
        except
          fActive:=false;
          beep;
          exit;
        end;

        //still here so F is ok
        //enabled
        FrozenValue:=f;
      end;

      fActive:=state;
    end;


  if state=false then
  begin
    //on disable or failure setting the state to true, also reset the option if it's allowed to increase/decrease
    allowDecrease:=false;
    allowIncrease:=false;
  end;

  //6.1+
  if state then
  begin
    //activating , before
    if assigned(fonactivate) then
      if not fonactivate(self, false, factive) then exit; //do not activate if it returns false
  end
  else
  begin
    if assigned(fondeactivate) then
      if not fondeactivate(self, false, factive) then exit;
  end;


end;

procedure TMemoryRecord.setVisible(state: boolean);
begin
  fVisible:=state;
end;

procedure TMemoryRecord.setShowAsHex(state:boolean);
begin
  fShowAsHex:=state;
end;

function TMemoryRecord.getByteSize: integer;
begin
  result:=0;
  case VarType of
    vtByte: result:=1;
    vtWord: result:=2;
    vtDWord: result:=4;
    vtSingle: result:=4;
    vtDouble: result:=8;
    vtQword: result:=8;
    vtString:
    begin
      result:=Extra.stringData.length;
      if extra.stringData.unicode then result:=result*2;
    end;

    vtByteArray: result:=extra.byteData.bytelength;
    vtBinary: result:=1+(extra.bitData.Bit+extra.bitData.bitlength div 8);
    vtCustom:
    begin
      if customtype<>nil then
        result:=customtype.bytesize;
    end;
  end;
end;

procedure TMemoryRecord.RefreshCustomType;
begin
  if vartype=vtCustom then
    CustomType:=GetCustomTypeFromName(fCustomTypeName);
end;

function TMemoryRecord.ReinterpretAddress(forceremovalofoldaddress: boolean=false): boolean;
//Returns false if interpretation failed (not really used for anything right now)
var
  a: ptrUint;
  s: string;
  i: integer;
begin
  if forceremovalofoldaddress then
  begin
    RealAddress:=0;
    baseaddress:=0;
  end;

  a:=symhandler.getAddressFromName(interpretableaddress,false,couldnotinterpretaddress);
  result:=not couldnotinterpretaddress;

  if result then
  begin

    s:=trim(interpretableaddress);
    fIsOffset:=(s<>'') and (s[1] in ['+','-']);
    baseaddress:=a;
  end;
end;

procedure TMemoryRecord.ApplyFreeze;
var oldvalue, newvalue: string;
  olddecimalvalue, newdecimalvalue: qword;
  oldfloatvalue, newfloatvalue: double;
begin
  if active and (VarType<>vtAutoAssembler) then
  begin
    try

      if allowIncrease or allowDecrease then
      begin
        //get the new value
        oldvalue:=frozenValue;
        newvalue:=GetValue;
        if showashex or (VarType in [vtByte..vtQword, vtCustom]) then
        begin
          //handle as a decimal


          if showAsHex then
          begin
            newdecimalvalue:=StrToInt('$'+newvalue);
            olddecimalvalue:=StrToInt('$'+oldvalue);
          end
          else
          begin
            newdecimalvalue:=StrToInt(newvalue);
            olddecimalvalue:=StrToInt(oldvalue);
          end;

          if (allowIncrease and (newdecimalvalue>olddecimalvalue)) or
             (allowDecrease and (newdecimalvalue<olddecimalvalue))
          then
            frozenvalue:=newvalue;

        end
        else
        if Vartype in [vtSingle, vtdouble] then
        begin
          //handle as floating point value
          oldfloatvalue:=strtofloat(oldvalue);
          newfloatvalue:=strtofloat(newvalue);

          if (allowIncrease and (newfloatvalue>oldfloatvalue)) or
             (allowDecrease and (newfloatvalue<oldfloatvalue))
          then
            frozenvalue:=newvalue;

        end;

        try
          setValue(frozenValue, true);
        except
          //new value gives an error, use the old one
          frozenvalue:=oldvalue;
        end;
      end
      else
        setValue(frozenValue, true);
    except
    end;
  end;
end;

function TMemoryRecord.getAddressString: string;
begin
  GetRealAddress;

  if length(pointeroffsets)>0 then
  begin
    if UnreadablePointer then
      result:='P->????????'
    else
      result:='P->'+inttohex(realaddress,8);
  end else
  begin
    if (realaddress=0) and (couldnotinterpretaddress) then
      result:='('+interpretableaddress+')'
    else
      result:=inttohex(realaddress,8);
  end;
end;

function TMemoryRecord.BinaryToString(b: pbytearray; bufsize: integer): string;
{Seperate function for the binary value since it's a bit more complex}
var
  temp,mask: qword;
begin
  temp:=0; //initialize

  if bufsize>8 then bufsize:=8;

  CopyMemory(@temp,b,bufsize);

  temp:=temp shr extra.bitData.Bit; //shift to the proper start
  mask:=qword($ffffffffffffffff) shl extra.bitData.bitlength; //create a mask that stripps of the excessive bits

  temp:=temp and (not mask); //temp now only contains the bits that are of meaning


  if not extra.bitData.showasbinary then
    result:=inttostr(temp)
  else
    result:=IntToBin(temp);
end;

function TMemoryRecord.GetValue: string;
var
  br: PtrUInt;
  bufsize: integer;
  buf: pointer;
  pb: pbyte absolute buf;
  pba: pbytearray absolute buf;
  pw: pword absolute buf;
  pdw: pdword absolute buf;
  ps: psingle absolute buf;
  pd: pdouble absolute buf;
  pqw: PQWord absolute buf;

  wc: PWideChar absolute buf;
  c: PChar absolute buf;

  i: integer;
begin



  result:='';

  bufsize:=getbytesize;
  if bufsize=0 then exit;

  if vartype=vtString then
  begin
    inc(bufsize);
    if Extra.stringData.unicode then
      inc(bufsize);
  end;

  getmem(buf,bufsize);



  GetRealAddress;

  if ReadProcessMemory(processhandle, pointer(realAddress), buf, bufsize,br) then
  begin
    case vartype of
      vtCustom:
      begin
        if customtype<>nil then
        begin
          if customtype.scriptUsesFloat then
            result:=FloatToStr(customtype.ConvertDataToFloat(buf))
          else
            if showashex then result:=inttohex(customtype.ConvertDataToInteger(buf),8) else if showassigned then result:=inttostr(integer(customtype.ConvertDataToInteger(buf))) else result:=inttostr(customtype.ConvertDataToInteger(buf));
        end
        else
          result:='error';
      end;

      vtByte : if showashex then result:=inttohex(pb^,2) else if showassigned then result:=inttostr(shortint(pb^)) else result:=inttostr(pb^);
      vtWord : if showashex then result:=inttohex(pw^,4) else if showassigned then result:=inttostr(SmallInt(pw^)) else result:=inttostr(pw^);
      vtDWord: if showashex then result:=inttohex(pdw^,8) else if showassigned then result:=inttostr(Integer(pdw^)) else result:=inttostr(pdw^);
      vtQWord: if showashex then result:=inttohex(pqw^,16) else if showassigned then result:=inttostr(Int64(pqw^)) else result:=inttostr(pqw^);
      vtSingle: if showashex then result:=inttohex(pdw^,8) else result:=FloatToStr(ps^);
      vtDouble: if showashex then result:=inttohex(pqw^,16) else result:=FloatToStr(pd^);
      vtBinary: result:=BinaryToString(buf,bufsize);

      vtString:
      begin
        pba[bufsize-1]:=0;
        if Extra.stringData.unicode then
        begin
          pba[bufsize-2]:=0;
          result:={ansitoutf8}(wc);
        end
        else
          result:={ansitoutf8}(c);
      end;

      vtByteArray:
      begin
        for i:=0 to bufsize-1 do
          if showashex then
            result:=result+inttohex(pba[i],2)+' '
          else
            result:=result+inttostr(pba[i])+' ';

        if result<>'' then
          result:=copy(result,1,length(result)-1); //cut off the last space
      end;


    end;
  end
  else
    result:='??';

  freemem(buf);
end;

function TMemoryrecord.canUndo: boolean;
begin
  result:=undovalue<>'';
end;

procedure TMemoryRecord.UndoSetValue;
begin
  if canUndo then
  begin
    try
      setvalue(UndoValue, false);
    except
    end;
  end;
end;

procedure TMemoryRecord.SetValue(v: string);
begin
  SetValue(v,false);
end;

procedure TMemoryRecord.SetValue(v: string; isFreezer: boolean);
{
Changes this address to the value V
}
var
  buf: pointer;
  bufsize: integer;
  x: PtrUInt;
  i: integer;
  pb: pbyte absolute buf;
  pba: pbytearray absolute buf;
  pw: pword absolute buf;
  pdw: pdword absolute buf;
  ps: psingle absolute buf;
  pd: pdouble absolute buf;
  pqw: PQWord absolute buf;

  li: PLongInt absolute buf;
  li64: PQWord absolute buf;

  wc: PWideChar absolute buf;
  c: PChar absolute buf;
  originalprotection: dword;

  bts: TBytes;
  mask: qword;
  temp: qword;
  temps: string;

  tempsw: widestring;
  tempsa: ansistring;

  mr: TMemoryRecord;

  unparsedvalue: string;
  check: boolean;
  fs: TFormatSettings;

  oldluatop: integer;
begin
  //check if it is a '(description)' notation

  unparsedvalue:=v;

  if vartype<>vtString then
  begin
    v:=trim(v);

    if (length(v)>2) and (v[1]='(') and (v[length(v)]=')') then
    begin
      //yes, it's a (description)
      temps:=copy(v, 2,length(v)-2);
      //search the addresslist for a entry with name (temps)

      mr:=TMemoryRecordTable(fOwner).getRecordWithDescription(temps);
      if mr<>nil then
        v:=mr.GetValue;

    end;
  end;

  if (not isfreezer) then
    undovalue:=GetValue;

  //and now set it for myself


  realAddress:=GetRealAddress; //quick update

  currentValue:={utf8toansi}(v);

  if fShowAsHex and (not (vartype in [vtSingle, vtDouble, vtByteArray, vtString] )) then
  begin
    currentvalue:=trim(currentValue);
    if length(currentvalue)>1 then
    begin
      if currentvalue[1]='-' then
      begin
        currentvalue:='-$'+copy(currentvalue,2,length(currentvalue));
      end
      else
        currentvalue:='$'+currentvalue;
    end;
  end;


  bufsize:=getbytesize;

  if (vartype=vtbinary) and (bufsize=3) then bufsize:=4;
  if (vartype=vtbinary) and (bufsize>4) then bufsize:=8;

  getmem(buf,bufsize);



  VirtualProtectEx(processhandle, pointer(realAddress), bufsize, PAGE_EXECUTE_READWRITE, originalprotection);
  try
    check:=ReadProcessMemory(processhandle, pointer(realAddress), buf, bufsize,x);
    if vartype in [vtBinary, vtByteArray] then //fill the buffer with the original byte
      if not check then exit;

    if (Vartype in [vtByte..vtDouble, vtCustom]) then
    begin
      //check if it's a bracket enclosed value [    ]
      CurrentValue:=trim(CurrentValue);
    end;

    case VarType of
      vtCustom:
      begin
        if customtype<>nil then
        Begin
          if customtype.scriptUsesFloat then
            customtype.ConvertFloatToData(strtofloat(currentValue), ps)
          else
            customtype.ConvertIntegerToData(strtoint(currentValue), pdw);

        end;
      end;


      vtByte: pb^:=StrToQWordEx(currentValue);
      vtWord: pw^:=StrToQWordEx(currentValue);
      vtDword: pdw^:=StrToQWordEx(currentValue);
      vtQword: pqw^:=StrToQWordEx(currentValue);
      vtSingle: if (not fShowAsHex) or (not TryStrToInt('$'+currentvalue, li^)) then
      begin
        try
          fs:=DefaultFormatSettings;
          ps^:=StrToFloat(currentValue, fs);
        except
          if fs.DecimalSeparator='.' then
            fs.DecimalSeparator:=','
          else
          fs.DecimalSeparator:='.';

          ps^:=StrToFloat(currentValue, fs);
        end;
      end;

      vtDouble: if (not fShowAsHex) or (not TryStrToQWord('$'+currentvalue, li64^)) then
      begin
        try
          fs:=DefaultFormatSettings;
          pd^:=StrToFloat(currentValue, fs);
        except
          if fs.DecimalSeparator='.' then
            fs.DecimalSeparator:=','
          else
          fs.DecimalSeparator:='.';

          pd^:=StrToFloat(currentValue, fs);
        end;
      end;

      vtBinary:
      begin
        if not Extra.bitData.showasbinary then
          temps:=currentValue
        else
          temps:=IntToStr(BinToInt(currentValue));

        temp:=StrToQWordEx(temps);
        temp:=temp shl extra.bitData.Bit;
        mask:=qword($ffffffffffffffff) shl extra.bitData.BitLength;
        mask:=not mask; //mask now contains the length of the bits (4 bits would be 0001111)


        mask:=mask shl extra.bitData.Bit; //shift the mask to the proper start position
        temp:=temp and mask; //cut off extra bits

        case bufsize of
          1: pb^:=(pb^ and (not mask)) or temp;
          2: pw^:=(pw^ and (not mask)) or temp;
          4: pdw^:=(pdw^ and (not mask)) or temp;
          8: pqw^:=(pqw^ and (not mask)) or temp;
        end;
      end;

      vtString:
      begin
        //x contains the max length in characters for the string
        if extra.stringData.length<length(currentValue) then
        begin
          extra.stringData.length:=length(currentValue);
          freemem(buf);
          bufsize:=getbytesize;
          getmem(buf, bufsize);
        end;

        x:=bufsize;
        if extra.stringData.unicode then
          x:=bufsize div 2; //each character is 2 bytes so only half the size is available

        if Extra.stringData.ZeroTerminate then
          x:=min(length(currentValue)+1,x) //also copy the zero terminator
        else
          x:=min(length(currentValue),x);


        tempsw:=currentvalue;
        tempsa:=currentvalue;

        //copy the string to the buffer
        for i:=0 to x-1 do
        begin
          if extra.stringData.unicode then
          begin
            wc[i]:=pwidechar(tempsw)[i];
          end
          else
          begin
            c[i]:=pchar(tempsa)[i];
          end;
        end;

        if extra.stringData.unicode then
          bufsize:=x*2 //two times the number of characters
        else
          bufsize:=x;
      end;

      vtByteArray:
      begin
        ConvertStringToBytes(currentValue, showAsHex, bts);
        if length(bts)>bufsize then
        begin
          //the user wants to input more bytes than it should have
          Extra.byteData.bytelength:=length(bts);  //so next time this won't happen again
          bufsize:=length(bts);
          freemem(buf);
          getmem(buf,bufsize);
          if not ReadProcessMemory(processhandle, pointer(realAddress), buf, bufsize,x) then exit;
        end;


        bufsize:=min(length(bts),bufsize);
        for i:=0 to bufsize-1 do
          if bts[i]<>-1 then
            pba[i]:=bts[i];
      end;
    end;

    WriteProcessMemory(processhandle, pointer(realAddress), buf, bufsize, x);


  finally
    VirtualProtectEx(processhandle, pointer(realAddress), bufsize, originalprotection, originalprotection);
  end;

  freemem(buf);

  frozenValue:=unparsedvalue;     //we got till the end, so update the frozen value
end;

function TMemoryRecord.getBaseAddress: ptrUint;
begin
    result:=BaseAddress;
end;

function TMemoryRecord.GetRealAddress: PtrUInt;
var
  check: boolean;
  realaddress, realaddress2: PtrUInt;
  i: integer;
  count: dword;
begin
  realAddress:=0;
  realAddress2:=0;

  if length(pointeroffsets)>0 then //it's a pointer
  begin
    //find the address this pointer points to
    result:=getPointerAddress(getBaseAddress, pointeroffsets, UnreadablePointer);
    if UnreadablePointer then
    begin
      realAddress:=0;
      result:=0;
    end;
  end
  else
    result:=getBaseAddress; //not a pointer

  self.RealAddress:=result;
end;



function MemRecHotkeyActionToText(action: TMemrecHotkeyAction): string;
begin
  //type TMemrecHotkeyAction=(mrhToggleActivation, mrhToggleActivationAllowIncrease, mrhToggleActivationAllowDecrease, mrhSetValue,
  //mrhIncreaseValue, mrhDecreaseValue);
  case action of
    mrhToggleActivation: result:='Toggle Activation';
    mrhToggleActivationAllowIncrease: result:='Toggle Activation Allow Increase';
    mrhToggleActivationAllowDecrease: result:='Toggle Activation Allow Decrease';
    mrhActivate: result:='Activate';
    mrhDeactivate: result:='Deactivate';
    mrhSetValue: result:='Set Value';
    mrhIncreaseValue: result:='Increase Value';
    mrhDecreaseValue: result:='Decrease Value';
  end;
end;

function TextToMemRecHotkeyAction(text: string): TMemrecHotkeyAction;
begin
  if text = 'Toggle Activation' then result:=mrhToggleActivation else
  if text = 'Toggle Activation Allow Increase' then result:=mrhToggleActivationAllowIncrease else
  if text = 'Toggle Activation Allow Decrease' then result:=mrhToggleActivationAllowDecrease else
  if text = 'Activate' then result:=mrhActivate else
  if text = 'Deactivate' then result:=mrhDeactivate else
  if text = 'Set Value' then result:=mrhSetValue else
  if text = 'Increase Value' then result:=mrhIncreaseValue else
  if text = 'Decrease Value' then result:=mrhDecreaseValue
  else
    result:=mrhToggleActivation;
end;

end.


