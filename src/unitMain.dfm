object FormBVA: TFormBVA
  Left = 193
  Top = 35
  Width = 969
  Height = 739
  AutoSize = True
  Caption = 'BVA Praktikum'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mmMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCoG: TLabel
    Left = 0
    Top = 353
    Width = 3
    Height = 13
  end
  object lblEqual: TLabel
    Left = 432
    Top = 151
    Width = 3
    Height = 13
  end
  object lblCog2: TLabel
    Left = 536
    Top = 357
    Width = 3
    Height = 13
  end
  object lblRotate: TLabel
    Left = 432
    Top = 200
    Width = 3
    Height = 13
  end
  object lblXdiff: TLabel
    Left = 432
    Top = 224
    Width = 3
    Height = 13
  end
  object lblYdiff: TLabel
    Left = 432
    Top = 248
    Width = 3
    Height = 13
  end
  object btnCompareObjs: TButton
    Left = 432
    Top = 119
    Width = 97
    Height = 25
    Caption = 'Bilder vergleichen'
    TabOrder = 0
    OnClick = btnCompareObjsClick
  end
  object grpboxExtended1: TGroupBox
    Left = 0
    Top = 504
    Width = 425
    Height = 81
    Caption = 'Erweiterte Funktionen'
    TabOrder = 1
    object btnGray1: TButton
      Left = 8
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Grauwertbild'
      TabOrder = 0
      OnClick = btnGray1Click
    end
    object btnMedian1: TButton
      Left = 8
      Top = 48
      Width = 137
      Height = 25
      Caption = 'Median'
      TabOrder = 1
      OnClick = btnMedian1Click
    end
    object btnBinary1: TButton
      Left = 144
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Bin'#228'rbild (aus Graubild)'
      TabOrder = 2
      OnClick = btnBinary1Click
    end
    object btnCoG1: TButton
      Left = 280
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Schwerpunkt bestimmen'
      TabOrder = 3
      OnClick = btnCoG1Click
    end
    object btnHisto1: TButton
      Left = 280
      Top = 48
      Width = 137
      Height = 25
      Caption = 'Histogramm'
      TabOrder = 4
      OnClick = btnHisto1Click
    end
    object btnKontur1: TButton
      Left = 144
      Top = 48
      Width = 137
      Height = 25
      Caption = 'Kontur erkennen'
      TabOrder = 5
      OnClick = btnKontur1Click
    end
  end
  object grpBoxPic1: TGroupBox
    Left = 0
    Top = 0
    Width = 425
    Height = 353
    Caption = 'Bild 1'
    TabOrder = 2
    object imgImage: TImage
      Left = 8
      Top = 16
      Width = 409
      Height = 329
      Proportional = True
      Stretch = True
    end
  end
  object grpBoxPic2: TGroupBox
    Left = 536
    Top = 0
    Width = 425
    Height = 353
    Caption = 'Bild 2'
    TabOrder = 3
    object imgImage2: TImage
      Left = 8
      Top = 16
      Width = 409
      Height = 329
      Proportional = True
      Stretch = True
    end
  end
  object grpboxExtended2: TGroupBox
    Left = 536
    Top = 504
    Width = 425
    Height = 81
    Caption = 'Erweiterte Funktionen'
    TabOrder = 4
    object btnGray2: TButton
      Left = 8
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Grauwertbild'
      TabOrder = 0
      OnClick = btnGray2Click
    end
    object btnMedian2: TButton
      Left = 8
      Top = 48
      Width = 137
      Height = 25
      Caption = 'Median'
      TabOrder = 1
      OnClick = btnMedian2Click
    end
    object btnBinary2: TButton
      Left = 144
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Bin'#228'rbild (aus Graubild)'
      TabOrder = 2
      OnClick = btnBinary2Click
    end
    object btnCoG2: TButton
      Left = 280
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Schwerpunkt bestimmen'
      TabOrder = 3
      OnClick = btnCoG2Click
    end
    object btnHisto2: TButton
      Left = 280
      Top = 48
      Width = 137
      Height = 25
      Caption = 'Histogramm'
      TabOrder = 4
      OnClick = btnHisto2Click
    end
    object btnKontur2: TButton
      Left = 144
      Top = 48
      Width = 137
      Height = 25
      Caption = 'Kontur erkennen'
      TabOrder = 5
      OnClick = btnKontur2Click
    end
  end
  object ChartHisto1: TChart
    Left = 0
    Top = 592
    Width = 425
    Height = 97
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'Histogramm Bild 1')
    TopAxis.Title.Caption = 'Grauwerthistogramm'
    View3D = False
    TabOrder = 5
    object srsGrayLevel: TBarSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clRed
      ShowInLegend = False
      Title = 'Grauwerthistogramm'
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Balken'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object ChartPolar1: TChart
    Left = 0
    Top = 373
    Width = 425
    Height = 124
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'Polarfunktion Bild 1')
    TopAxis.Title.Caption = 'Grauwerthistogramm'
    View3D = False
    TabOrder = 6
    object srsPolar1: TFastLineSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clRed
      ShowInLegend = False
      Title = 'Polarfunktion'
      LinePen.Color = clGreen
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object ChartPolar2: TChart
    Left = 536
    Top = 373
    Width = 425
    Height = 124
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'Polarfunktion Bild 2')
    TopAxis.Title.Caption = 'Grauwerthistogramm'
    View3D = False
    TabOrder = 7
    object srsPolar2: TFastLineSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clRed
      ShowInLegend = False
      Title = 'Polarfunktion'
      LinePen.Color = clGreen
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object ChartHisto2: TChart
    Left = 536
    Top = 592
    Width = 425
    Height = 97
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'Histogramm Bild 2')
    TopAxis.Title.Caption = 'Grauwerthistogramm'
    View3D = False
    TabOrder = 8
    object srsGrayLevel2: TBarSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clRed
      ShowInLegend = False
      Title = 'Grauwerthistogramm'
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Balken'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object mmMenu: TMainMenu
    Left = 472
    Top = 15
    object miFile: TMenuItem
      Caption = 'Datei'
      object miOpen1: TMenuItem
        Caption = 'Bild 1 '#246'ffnen'
        OnClick = miOpen1Click
      end
      object miOpen2: TMenuItem
        Caption = 'Bild 2 '#246'ffnen'
        OnClick = miOpen2Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miClose: TMenuItem
        Caption = 'Beenden'
        OnClick = miCloseClick
      end
    end
    object Optionen1: TMenuItem
      Caption = 'Optionen'
      object miExtended: TMenuItem
        Caption = 'Erweiterte Funktionen'
        Checked = True
        OnClick = miExtendedClick
      end
      object Vergleichsmethode1: TMenuItem
        Caption = 'Vergleichsmethode'
        object miPolarcoding: TMenuItem
          Caption = 'Polarcoding'
          Checked = True
          OnClick = miPolarcodingClick
        end
        object miPolarMitKontur: TMenuItem
          Caption = 'Polarcoding mit Richtungsabh'#228'ngigkeit'
          OnClick = miPolarMitKonturClick
        end
      end
    end
  end
  object opdOpenImage: TOpenPictureDialog
    Left = 440
    Top = 15
  end
end
