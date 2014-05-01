unit genericHotkey;

{$mode delphi}

interface

uses
  Classes, SysUtils, cefuncproc, windows;

type TGenericHotkey=class
  private
    FOwner : HWND;
  public
    keys: TKeycombo;
    onNotify: TNotifyEvent;
    procedure setDelayBetweenActivate(delay: integer);
    function getDelayBetweenActivate: integer;
    constructor create(Owner : HWND; routine: TNotifyEvent; keys: TKeycombo);
    destructor destroy; override;
  published
    property delayBetweenActivate: integer read getDelayBetweenActivate write setDelayBetweenActivate;
end;

implementation

uses hotkeyhandler;

procedure TGenericHotkey.setDelayBetweenActivate(delay: integer);
begin
  CSKeys.enter;
  try
    getGenericHotkeyKeyItem(self).delayBetweenActivate:=delay;
  finally
    CSKeys.leave;
  end;
end;

function TGenericHotkey.getDelayBetweenActivate: integer;
begin
  CSKeys.enter;
  try
    result:=getGenericHotkeyKeyItem(self).delayBetweenActivate;
  finally
    CSKeys.leave;
  end;
end;

constructor TGenericHotkey.create(Owner : HWND; routine: TNotifyEvent; keys: TKeycombo);
begin
  FOWner := OWner;
  //register hotkey
  onNotify:=routine;
  self.keys:=keys;
  RegisterHotKey2(FOwner, -1, keys, nil,self);
end;

destructor TGenericHotkey.destroy;
begin
  //unregister hotkey
  UnregisterGenericHotkey(self);

  Inherited destroy;
end;

end.

