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
  object btnInject: TButton
    Left = 120
    Top = 68
    Width = 147
    Height = 25
    Caption = 'Inject this script !'
    TabOrder = 2
    OnClick = btnInjectClick
  end
end
