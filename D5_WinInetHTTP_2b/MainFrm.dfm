object MainForm: TMainForm
  Left = 217
  Top = 106
  Width = 566
  Height = 354
  Caption = 'Reanudar la descarga con WinInet - Delphi'
  Color = 15922418
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object i_icono: TImage
    Left = 4
    Top = 7
    Width = 32
    Height = 32
    AutoSize = True
  end
  object l_wininet: TLabel
    Left = 42
    Top = 17
    Width = 94
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic para navegar al artículo completo'
    Caption = 'WinInet y HTTP (II)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = l_wininetClick
  end
  object l_sintesis: TLabel
    Left = 8
    Top = 50
    Width = 119
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic para navegar al capítulo'
    Caption = 'Reanudando la descarga'
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = l_sintesisClick
  end
  object TLabel
    Left = 27
    Top = 142
    Width = 77
    Height = 13
    Caption = 'JM - Mayo/2004'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object l_jm: TLabel
    Left = 16
    Top = 118
    Width = 102
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic aquí para navegar a "La web de JM"'
    Caption = 'www.lawebdejm.com'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = True
    OnClick = l_jmClick
  end
  object s_borde: TShape
    Left = 140
    Top = 4
    Width = 413
    Height = 318
    Anchors = [akLeft, akTop, akRight, akBottom]
    Brush.Color = clBtnFace
    Pen.Color = 12164479
  end
  object l_rincones: TLabel
    Left = 9
    Top = 77
    Width = 117
    Height = 26
    Cursor = crHandPoint
    Hint = 
      'Haz clic para navegar a la página de "Los rincones del API Win32' +
      '"'
    Alignment = taCenter
    AutoSize = False
    Caption = 'Los rincones del API Win32'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Layout = tlCenter
    WordWrap = True
    OnClick = l_rinconesClick
  end
  object p_funciones: TPanel
    Left = 141
    Top = 5
    Width = 408
    Height = 313
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object TLabel
      Left = 12
      Top = 8
      Width = 109
      Height = 13
      Caption = 'Descargas pendientes:'
    end
    object Label2: TLabel
      Left = 12
      Top = 151
      Width = 117
      Height = 13
      Caption = 'Descargar en la carpeta:'
    end
    object Bevel1: TBevel
      Left = 124
      Top = 15
      Width = 278
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label1: TLabel
      Left = 45
      Top = 122
      Width = 84
      Height = 13
      Caption = 'URL a descargar:'
    end
    object TLabel
      Left = 12
      Top = 232
      Width = 83
      Height = 13
      Caption = 'Log de descarga:'
    end
    object Bevel2: TBevel
      Left = 98
      Top = 239
      Width = 307
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Panel1: TPanel
      Left = 135
      Top = 147
      Width = 268
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWindow
      TabOrder = 3
      object Image1: TImage
        Left = 250
        Top = 2
        Width = 16
        Height = 14
        Cursor = crHandPoint
        Hint = 'Haz clic para examinar las carpetas'
        Anchors = [akTop, akRight]
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170D6020000424DD60200000000000036000000280000001000
          00000E0000000100180000000000A0020000120B0000120B0000000000000000
          0000EEEEEF9D6967998180B4B4B6D4D7DAEDEFF0FDFDFDFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD5BFC0BF5D3FC76134B75D3AAD64
          47A56556987674A5A4A6C5CBCEE3E6E8FCFDFDFDFDFDFFFFFFFFFFFFFFFFFFFF
          FFFFCEA7A5C16D55D06E40D46F3CD36C39D06736C96134B45535A157419A6D5F
          A7877FB7ABACD5D6D8F9FAFBFFFFFFFFFFFFCA9A97D58C74CC7755D57C50D276
          49D27345D1703FD36E3BD46E3BD26736CA6434BE5B33A5543EE7E2E2FFFFFFFF
          FFFFCA9B99DE9D85DA9377DA916DD98D66D8875FD68057D17244CF6B3BCF6D3C
          D16E3DD26D3CC46436D8BFBAFFFFFFFFFFFFC19695E1A18AE1A38BE1A588E0A1
          81DE9B7ADD9572DB8E69D78259D17143CF6B3ACF6A39C26638BC7964F8F3F3FF
          FFFFB3807CE7B19BE0A690DDA793ECC0A9E7B59CE5AE93E3A78BE1A283DE9978
          D98B65D47B50C1673BC67248D2AEA6FFFFFFB4726CEFC2AEE9B7A2D09586E6C0
          B0EBC5B4EEC8B5ECC1ABE8B79FE5B196E4AC90E1A386D29173D5926DCC9684FD
          FCFCB8726AF5D2C0F4CEBAE7B7A3CE8E7FE4B39FE2B2A1DFAD9BEFCDBCEFCCBA
          ECC4B0EABCA7E1B5A0E4BDA7D6A28EE5D2D1BB7871F8DDCDF5D5C3F4CFBBF4CB
          B5EEBEA8E9B19ADFA087D09384EFD4C8EFD1C4EFD0C1EAC8B9E9C9BAF1D2BFD9
          B8B1BF8078FDE7D9F7DCCDF5D5C4F3CEBCF1C9B5F2C6B0EFBFA7E5AC94DC9E88
          DEA089DFA08AA97974E2CCC5E8CEC5C59B96B77670FBE6D8FCE8DAF8DED0F7D9
          CAF6D6C3E8BAA7E1AE9BE9B49EEEBAA2F0BA9FE0957A8A605EF4F4F5FFFFFFF8
          F5F5DBC4C4E2BFB5F8E1D3FDE9DCFBE2D3DDB4A7C0928FD4ACA9D5B6B0CB948D
          CE988ED19588B39C9CFCFCFCFFFFFFFFFFFFFEFEFED2B2B2B57976BE7F78C78D
          84C9BAB9FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFEFCFCFDFDFDFFFFFFFFFFFFFF
          FFFF}
        ShowHint = True
        OnClick = Image1Click
      end
    end
    object lb_url: TListBox
      Left = 12
      Top = 29
      Width = 392
      Height = 56
      Anchors = [akLeft, akTop, akRight]
      IntegralHeight = True
      ItemHeight = 13
      TabOrder = 0
      OnClick = lb_urlClick
    end
    object b_eliminar: TButton
      Left = 345
      Top = 88
      Width = 59
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'Eliminar'
      TabOrder = 1
      OnClick = b_eliminarClick
    end
    object e_carpeta: TEdit
      Left = 138
      Top = 150
      Width = 243
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      BorderStyle = bsNone
      TabOrder = 2
    end
    object b_descargar: TButton
      Left = 318
      Top = 177
      Width = 81
      Height = 22
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Descargar'
      Default = True
      TabOrder = 4
      OnClick = b_descargarClick
    end
    object progreso: TProgressBar
      Left = 12
      Top = 208
      Width = 390
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      Min = 0
      Max = 100
      Smooth = True
      TabOrder = 5
    end
    object lb_log: TListBox
      Left = 12
      Top = 250
      Width = 389
      Height = 57
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 6
    end
    object Panel2: TPanel
      Left = 135
      Top = 118
      Width = 268
      Height = 21
      Alignment = taLeftJustify
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = ' http://'
      Color = clWindow
      TabOrder = 7
      object e_url: TEdit
        Left = 35
        Top = 2
        Width = 227
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        TabOrder = 0
        Text = 
          'users.servicios.retecal.es/sapivi/prog/oracle/iniciacion_oracle.' +
          'zip'
      end
    end
  end
end
