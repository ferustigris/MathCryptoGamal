object Form1: TForm1
  Left = 277
  Top = 49
  Width = 416
  Height = 682
  Caption = #1069#1083#1100'-'#1043#1072#1084#1072#1083#1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object mMsg: TMemo
    Left = 0
    Top = 0
    Width = 408
    Height = 209
    Align = alTop
    Lines.Strings = (
      'original message')
    TabOrder = 0
  end
  object sbbar: TStatusBar
    Left = 0
    Top = 618
    Width = 408
    Height = 18
    Panels = <
      item
        Width = 200
      end>
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 209
    Width = 408
    Height = 105
    Align = alTop
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 2
    DesignSize = (
      408
      105)
    object Label1: TLabel
      Left = 2
      Top = 15
      Width = 404
      Height = 13
      Align = alTop
      Caption = #1044#1083#1080#1085#1072' '#1082#1083#1102#1095#1072
    end
    object meKeyLength: TEdit
      Left = 8
      Top = 32
      Width = 386
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '2'
    end
  end
  object bProgress: TProgressBar
    Left = 0
    Top = 602
    Width = 408
    Height = 16
    Align = alBottom
    Anchors = [akRight, akBottom]
    Max = 10000
    TabOrder = 3
  end
  object log: TMemo
    Left = 0
    Top = 314
    Width = 408
    Height = 288
    Align = alClient
    TabOrder = 4
  end
  object mm: TMainMenu
    Left = 136
    Top = 104
    object N1: TMenuItem
      Caption = #1040#1083#1075#1086#1088#1080#1090#1084
      object nGen: TMenuItem
        Caption = #1043#1077#1085#1077#1088#1072#1094#1080#1103' '#1082#1083#1102#1095#1072
        OnClick = nGenClick
      end
      object nCheck: TMenuItem
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        OnClick = nCheckClick
      end
      object nClose: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = nCloseClick
      end
    end
  end
end
