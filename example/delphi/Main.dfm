object fmSample: TfmSample
  Left = 0
  Top = 0
  Caption = 'Sample cheatengine-library for delphi'
  ClientHeight = 433
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 376
    Top = 0
    Width = 229
    Height = 433
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 0
    object ltProcess: TListBox
      AlignWithMargins = True
      Left = 4
      Top = 190
      Width = 221
      Height = 232
      Margins.Bottom = 10
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
    end
    object btnProcesses: TButton
      Left = 64
      Top = 126
      Width = 107
      Height = 25
      Caption = 'process list'
      TabOrder = 1
      OnClick = btnProcessesClick
    end
    object btnOpenProcess: TButton
      Left = 40
      Top = 157
      Width = 147
      Height = 25
      Caption = 'open selected process'
      TabOrder = 2
      OnClick = btnOpenProcessClick
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 212
      Height = 105
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 3
      object btnLoad: TButton
        Left = 62
        Top = 16
        Width = 99
        Height = 25
        Caption = 'load library !'
        TabOrder = 0
        OnClick = btnLoadClick
      end
      object btnUnload: TButton
        Left = 62
        Top = 47
        Width = 99
        Height = 25
        Caption = 'unload library !'
        TabOrder = 1
        OnClick = btnUnloadClick
      end
    end
  end
  object memoScript: TMemo
    AlignWithMargins = True
    Left = 43
    Top = 99
    Width = 297
    Height = 319
    Margins.Bottom = 10
    Lines.Strings = (
      'Put here your asm script !')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 120
    Top = 68
    Width = 147
    Height = 25
    Caption = 'Inject this script !'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 160
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 256
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 4
    OnClick = Button3Click
  end
end
