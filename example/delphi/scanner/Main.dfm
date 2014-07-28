object fmScanner: TfmScanner
  Left = 0
  Top = 0
  Caption = 'cheatengine-library for delphi : Scanner example'
  ClientHeight = 602
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 58
    Width = 42
    Height = 13
    Caption = 'Value 1 :'
  end
  object Label2: TLabel
    Left = 264
    Top = 58
    Width = 42
    Height = 13
    Caption = 'Value 2 :'
  end
  object Label3: TLabel
    Left = 16
    Top = 93
    Width = 57
    Height = 13
    Caption = 'Scan Type :'
  end
  object Label4: TLabel
    Left = 16
    Top = 131
    Width = 60
    Height = 13
    Caption = 'Value Type :'
  end
  object Panel2: TPanel
    Left = 499
    Top = 0
    Width = 229
    Height = 602
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 0
    object ltProcess: TListBox
      AlignWithMargins = True
      Left = 4
      Top = 240
      Width = 221
      Height = 351
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
  object btnFirstScan: TButton
    Left = 87
    Top = 8
    Width = 75
    Height = 25
    Caption = 'First Scan'
    Enabled = False
    TabOrder = 1
    OnClick = btnFirstScanClick
  end
  object btnNextScan: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Next Scan'
    Enabled = False
    TabOrder = 2
    OnClick = btnNextScanClick
  end
  object cbScanType: TComboBox
    Left = 98
    Top = 90
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 3
    Text = 'Exact Value'
    OnChange = cbScanTypeChange
    Items.Strings = (
      'UnknownValue'
      'Exact Value'
      'Value Between'
      'Bigger Than'
      'Smaller Than'
      'Increased Value'
      'Increased ValueBy'
      'Decreased Value'
      'Decreased Value By'
      'Changed Value'
      'Unchanged Value')
  end
  object edtValue1: TEdit
    Left = 72
    Top = 55
    Width = 171
    Height = 21
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    TabOrder = 4
  end
  object edtValue2: TEdit
    Left = 322
    Top = 55
    Width = 171
    Height = 21
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    TabOrder = 5
  end
  object cbValueType: TComboBox
    Left = 98
    Top = 128
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemIndex = 3
    TabOrder = 6
    Text = '4 Bytes'
    OnChange = cbValueTypeChange
    Items.Strings = (
      'Binary'
      'Byte'
      '2 Bytes'
      '4 Bytes'
      '8 Bytes'
      'Float'
      'Double'
      'String')
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 168
    Width = 477
    Height = 106
    Caption = 'MemoryScan options'
    TabOrder = 7
    object Label5: TLabel
      Left = 11
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Start :'
    end
    object Label6: TLabel
      Left = 240
      Top = 24
      Width = 26
      Height = 13
      Caption = 'Stop:'
    end
    object edtStartScan: TEdit
      Left = 56
      Top = 21
      Width = 161
      Height = 21
      BiDiMode = bdRightToLeft
      MaxLength = 16
      ParentBiDiMode = False
      TabOrder = 0
      Text = '0000000000000000'
      OnChange = edtStartScanChange
    end
    object edtEndScan: TEdit
      Left = 306
      Top = 21
      Width = 159
      Height = 21
      BiDiMode = bdRightToLeft
      CharCase = ecUpperCase
      MaxLength = 16
      ParentBiDiMode = False
      TabOrder = 1
      Text = '7FFFFFFFFFFFFFFF'
      OnChange = edtEndScanChange
    end
    object cbWritable: TCheckBox
      Left = 56
      Top = 56
      Width = 65
      Height = 17
      AllowGrayed = True
      Caption = 'Writable'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbExecutable: TCheckBox
      Left = 152
      Top = 56
      Width = 82
      Height = 17
      AllowGrayed = True
      Caption = 'Executable'
      State = cbGrayed
      TabOrder = 3
    end
    object cbCopyOnWrite: TCheckBox
      Left = 240
      Top = 56
      Width = 97
      Height = 17
      AllowGrayed = True
      Caption = 'CopyOnWrite'
      TabOrder = 4
    end
  end
  object lvScanner: TListView
    Left = 16
    Top = 384
    Width = 477
    Height = 207
    Columns = <
      item
        Caption = 'Address'
        Width = 200
      end
      item
        Caption = 'Value'
        Width = 200
      end>
    OwnerData = True
    TabOrder = 8
    ViewStyle = vsReport
    OnData = lvScannerData
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 280
    Width = 477
    Height = 89
    Caption = 'Optional options'
    TabOrder = 9
    object chkUnicode: TCheckBox
      Left = 24
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Unicode'
      TabOrder = 0
      OnClick = chkUnicodeClick
    end
    object chkCase: TCheckBox
      Left = 24
      Top = 47
      Width = 97
      Height = 17
      Caption = 'Case sensitive'
      TabOrder = 1
      OnClick = chkCaseClick
    end
    object cbFastScan: TCheckBox
      Left = 169
      Top = 24
      Width = 72
      Height = 17
      Caption = 'fast scan'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = cbFastScanClick
    end
    object rbAlignment: TRadioButton
      Left = 322
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Alignment'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
    object rbLastDigits: TRadioButton
      Left = 322
      Top = 47
      Width = 113
      Height = 17
      Caption = 'Last bits'
      Enabled = False
      TabOrder = 4
    end
    object edtAlignment: TEdit
      Left = 256
      Top = 24
      Width = 50
      Height = 21
      BiDiMode = bdRightToLeft
      NumbersOnly = True
      ParentBiDiMode = False
      ReadOnly = True
      TabOrder = 5
      Text = '4'
    end
  end
  object btnNewScan: TButton
    Left = 6
    Top = 8
    Width = 75
    Height = 25
    Caption = 'New Scan'
    Enabled = False
    TabOrder = 10
    OnClick = btnNewScanClick
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 448
    Top = 256
  end
end
