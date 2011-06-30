object ProgresoFrm: TProgresoFrm
  Left = 230
  Top = 140
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ActiveControl = cb_cerrar
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Descarga de archivos'
  ClientHeight = 232
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object l_guardando: TLabel
    Left = 12
    Top = 63
    Width = 365
    Height = 13
    AutoSize = False
    Caption = 'Obteniendo información del archivo:'
  end
  object l_url: TLabel
    Left = 12
    Top = 79
    Width = 370
    Height = 13
    AutoSize = False
    Caption = 'XXXXXXXX de www.YYYY.com'
  end
  object l_tiempo: TLabel
    Left = 12
    Top = 112
    Width = 83
    Height = 13
    Caption = 'Tiempo estimado:'
  end
  object l_progreso: TLabel
    Left = 123
    Top = 112
    Width = 254
    Height = 13
    AutoSize = False
  end
  object l_descargar: TLabel
    Left = 12
    Top = 134
    Width = 58
    Height = 13
    Caption = 'Descargar a'
  end
  object TLabel
    Left = 12
    Top = 154
    Width = 106
    Height = 13
    Caption = 'Tasa de transferencia:'
  end
  object l_tasa: TLabel
    Left = 123
    Top = 154
    Width = 254
    Height = 13
    AutoSize = False
  end
  object i_completo: TImage
    Left = 12
    Top = 17
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      07544269746D617062020000424D620200000000000062000000280000002000
      000020000000010004000000000000020000C40E0000C40E00000B0000000B00
      000000000000FFFFFF00FF00FF0000FF00000080000000FFFF00008080000000
      FF00C0C0C00080808000FFFFFF00222222222200000000000000000002222222
      2222299999999999999999999022222222222918888888888888888899022222
      2222291888811111188888889990222222222918111999999111888899902222
      2222291899900000099984489990222222222918888999999888833899902000
      0000091888888888888888889990666666666918888888888888888899906500
      0000091111111111111111119990659888888898888888888888888889906591
      1111111988888888888888888890659111111111999999999999999999926591
      1111871111118060222222222222659111187781111180602222222722226591
      1187777111118060222222777222659118779778111180602222277777226591
      1778177711118060222277777772659111111877811180602222227772226591
      1111117771118060222222777222659111111187781180602222227722226591
      1111111777118060222227772222659111111111111180602222277222226591
      1111111111118060222277222222659111111111111180602777222222226591
      1188888888818060222222222222659110000000008180602222222222226599
      9911888990999060222222222222655555911899055555602222222222222666
      6669189006666662222222222222222222911889022222222222222222222222
      2299999992222222222222222222}
    Transparent = True
    Visible = False
  end
  object l_completa: TLabel
    Left = 69
    Top = 34
    Width = 92
    Height = 13
    Caption = 'Descarga completa'
    Transparent = True
    Visible = False
  end
  object avi: TAnimate
    Left = 12
    Top = -1
    Width = 272
    Height = 60
    Active = False
  end
  object b_abrir: TButton
    Left = 144
    Top = 201
    Width = 75
    Height = 23
    Caption = 'A&brir'
    Enabled = False
    TabOrder = 1
    OnClick = AbrirArchivo
  end
  object pb_progreso: TProgressBar
    Left = 12
    Top = 95
    Width = 369
    Height = 13
    Min = 0
    Max = 0
    TabOrder = 2
    Visible = False
  end
  object cb_cerrar: TCheckBox
    Left = 12
    Top = 177
    Width = 213
    Height = 17
    Caption = '&Cerrar el diálogo al terminar la descarga.'
    TabOrder = 3
  end
  object b_abrirCarpeta: TButton
    Left = 226
    Top = 201
    Width = 75
    Height = 23
    Caption = '&Abrir carpeta'
    Enabled = False
    TabOrder = 4
    OnClick = AbrirCarpeta
  end
  object b_cancelar: TButton
    Left = 309
    Top = 201
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancelar'
    Default = True
    Enabled = False
    TabOrder = 5
    OnClick = b_cancelarClick
  end
end
