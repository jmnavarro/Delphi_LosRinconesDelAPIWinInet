object MainForm: TMainForm
  Left = 166
  Top = 141
  Width = 529
  Height = 323
  Caption = 'Pruebas con WinInet - Delphi'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sh_funcion: TShape
    Left = 4
    Top = 148
    Width = 143
    Height = 26
    Brush.Color = clBtnFace
    Pen.Color = 12164479
  end
  object i_icono: TImage
    Left = 7
    Top = 7
    Width = 32
    Height = 32
    AutoSize = True
  end
  object l_wininet: TLabel
    Left = 47
    Top = 9
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
    Left = 61
    Top = 25
    Width = 51
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic para navegar al la página de Síntesis'
    Caption = 'Síntesis 16'
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
    Left = 31
    Top = 82
    Width = 85
    Height = 13
    Caption = 'JM - Agosto/2003'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object l_jm: TLabel
    Left = 31
    Top = 82
    Width = 13
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic aquí para navegar a "La web de JM"'
    Caption = 'JM'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = True
    OnClick = l_jmClick
  end
  object TShape
    Left = 145
    Top = 4
    Width = 371
    Height = 287
    Anchors = [akLeft, akTop, akRight, akBottom]
    Brush.Color = clBtnFace
    Pen.Color = 12164479
  end
  object l_url: TLabel
    Left = 12
    Top = 154
    Width = 78
    Height = 13
    Caption = 'Login de usuario'
    Transparent = True
    OnClick = CambioFunciones
  end
  object l_conexion: TLabel
    Left = 12
    Top = 194
    Width = 92
    Height = 13
    Cursor = crHandPoint
    Caption = 'Envío de formulario'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = CambioFunciones
  end
  object TLabel
    Left = 4
    Top = 120
    Width = 52
    Height = 13
    Caption = 'Funciones:'
  end
  object l_rincones: TLabel
    Left = 19
    Top = 50
    Width = 105
    Height = 24
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
    WordWrap = True
    OnClick = l_rinconesClick
  end
  object p_funciones: TPanel
    Left = 147
    Top = 5
    Width = 365
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object pc_funciones: TPageControl
      Left = -2
      Top = -27
      Width = 369
      Height = 311
      ActivePage = ts_login
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      TabStop = False
      object ts_login: TTabSheet
        object Label2: TLabel
          Left = 9
          Top = 20
          Width = 23
          Height = 13
          Caption = 'URL:'
        end
        object Label4: TLabel
          Left = 8
          Top = 85
          Width = 122
          Height = 13
          Caption = 'Tipo de ventana de login:'
        end
        object Bevel2: TBevel
          Left = 139
          Top = 92
          Width = 214
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object Bevel3: TBevel
          Left = 3
          Top = 249
          Width = 358
          Height = 17
          Anchors = [akLeft, akRight, akBottom]
          Shape = bsTopLine
        end
        object Label5: TLabel
          Left = 8
          Top = 161
          Width = 53
          Height = 13
          Caption = 'Contenido:'
        end
        object Bevel4: TBevel
          Left = 67
          Top = 168
          Width = 286
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object Label6: TLabel
          Left = 8
          Top = 52
          Width = 43
          Height = 13
          Caption = 'Usuario: '
        end
        object Label7: TLabel
          Left = 112
          Top = 52
          Width = 63
          Height = 13
          Caption = 'Contraseña: '
        end
        object Label8: TLabel
          Left = 53
          Top = 52
          Width = 35
          Height = 13
          Caption = 'sintesis'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 178
          Top = 52
          Width = 26
          Height = 13
          Caption = 'pepin'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Button1: TButton
          Left = 285
          Top = 258
          Width = 75
          Height = 22
          Anchors = [akRight, akBottom]
          Caption = 'Acceder'
          TabOrder = 0
          OnClick = Button1Click
        end
        object e_url: TEdit
          Left = 41
          Top = 16
          Width = 313
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
          Text = 'http://www.lawebdejm.com/prog/win32/img/prv/datos.txt'
        end
        object rb_estandar: TRadioButton
          Left = 48
          Top = 108
          Width = 113
          Height = 17
          Caption = 'Estándar'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object rb_personalizada: TRadioButton
          Left = 48
          Top = 128
          Width = 113
          Height = 17
          Caption = 'Personalizada'
          TabOrder = 3
        end
        object m_contenido: TMemo
          Left = 8
          Top = 181
          Width = 345
          Height = 59
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clBtnFace
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 4
        end
      end
      object ts_sendform: TTabSheet
        ImageIndex = 1
        object TLabel
          Left = 35
          Top = 28
          Width = 41
          Height = 13
          Caption = 'Nombre:'
        end
        object Label3: TLabel
          Left = 53
          Top = 56
          Width = 23
          Height = 13
          Caption = 'País:'
        end
        object Label1: TLabel
          Left = 12
          Top = 84
          Width = 64
          Height = 13
          Caption = 'Comentarios:'
        end
        object Bevel1: TBevel
          Left = 8
          Top = 249
          Width = 345
          Height = 16
          Anchors = [akLeft, akRight, akBottom]
          Shape = bsTopLine
        end
        object b_enviar: TButton
          Left = 278
          Top = 258
          Width = 75
          Height = 21
          Anchors = [akRight, akBottom]
          Caption = 'Enviar'
          TabOrder = 0
          OnClick = b_enviarClick
        end
        object e_nombre: TEdit
          Left = 83
          Top = 24
          Width = 270
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Text = 'Juancito Pérez Pí'
        end
        object e_pais: TEdit
          Left = 83
          Top = 52
          Width = 270
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Text = 'España'
        end
        object m_comentario: TMemo
          Left = 83
          Top = 80
          Width = 270
          Height = 159
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 3
        end
      end
    end
  end
  object p_aux: TPanel
    Left = 143
    Top = 149
    Width = 6
    Height = 24
    BevelOuter = bvNone
    TabOrder = 1
  end
end
