object MainForm: TMainForm
  Left = 111
  Top = 103
  Width = 577
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sh_funcion: TShape
    Left = 4
    Top = 148
    Width = 127
    Height = 26
    Brush.Color = clBtnFace
    Pen.Color = 12164479
  end
  object i_icono: TImage
    Left = 10
    Top = 7
    Width = 32
    Height = 32
    AutoSize = True
  end
  object l_wininet: TLabel
    Left = 55
    Top = 9
    Width = 53
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic para navegar al artículo completo'
    Caption = 'WinInet (I)'
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
    Left = 56
    Top = 25
    Width = 51
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic para navegar al la página de Síntesis'
    Caption = 'Síntesis 14'
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
    Left = 24
    Top = 79
    Width = 72
    Height = 13
    Caption = 'JM - Abril/2003'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object l_jm: TLabel
    Left = 24
    Top = 79
    Width = 13
    Height = 13
    Cursor = crHandPoint
    Hint = 'Haz clic aquí para navegar a "La página de JM"'
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
    Left = 129
    Top = 4
    Width = 435
    Height = 287
    Anchors = [akLeft, akTop, akRight, akBottom]
    Brush.Color = clBtnFace
    Pen.Color = 12164479
  end
  object l_url: TLabel
    Left = 12
    Top = 154
    Width = 77
    Height = 13
    Caption = 'Manejo de URLs'
    Transparent = True
    OnClick = CambioFunciones
  end
  object l_conexion: TLabel
    Left = 12
    Top = 194
    Width = 105
    Height = 13
    Cursor = crHandPoint
    Caption = 'Estado de la conexión'
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
    Left = 12
    Top = 47
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
    Left = 131
    Top = 5
    Width = 429
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object pc_funciones: TPageControl
      Left = -2
      Top = -27
      Width = 433
      Height = 311
      ActivePage = ts_url
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      TabStop = False
      object ts_url: TTabSheet
        object pc_url: TPageControl
          Left = 2
          Top = 6
          Width = 424
          Height = 278
          ActivePage = ts_canonicalize
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object ts_canonicalize: TTabSheet
            Caption = 'InternetCanonicalizeUrl'
            object TLabel
              Left = 34
              Top = 18
              Width = 23
              Height = 13
              Caption = 'URL:'
            end
            object TLabel
              Left = 11
              Top = 49
              Width = 48
              Height = 13
              Caption = 'Opciones:'
            end
            object TLabel
              Left = 8
              Top = 151
              Width = 52
              Height = 13
              Caption = 'Resultado:'
            end
            object e_canonicalizeUrl: TEdit
              Left = 63
              Top = 14
              Width = 345
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              MaxLength = 256
              TabOrder = 0
              Text = 
                'http://juancín:contraseña@www.servidor.com/ruta/recurso con cara' +
                'cteres inválidos.html?opción=valor'
            end
            object CanonicalizeFlags: TCheckListBox
              Left = 63
              Top = 49
              Width = 345
              Height = 84
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 16
              Items.Strings = (
                'ICU_BROWSER_MODE'
                'ICU_NO_ENCODE'
                'ICU_DECODE'
                'ICU_ENCODE_PERCENT'
                'ICU_ENCODE_SPACES_ONLY')
              Style = lbOwnerDrawFixed
              TabOrder = 1
            end
            object e_canonicalizeResult: TEdit
              Left = 63
              Top = 147
              Width = 345
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              MaxLength = 256
              ReadOnly = True
              TabOrder = 2
            end
            inline CanonicalizeUrlFrame: TEjecutarFrame
              Top = 204
              Width = 416
              Height = 46
              Align = alBottom
              TabOrder = 3
              inherited p_pie: TPanel
                Top = 5
                Width = 416
                inherited l_retorno: TLabel
                  Width = 283
                end
                inherited Bevel1: TBevel
                  Width = 404
                end
                inherited b_ejecutar: TButton
                  Left = 344
                end
              end
            end
          end
          object ts_combine: TTabSheet
            Caption = 'InternetCombineUrl'
            ImageIndex = 1
            object TLabel
              Left = 20
              Top = 18
              Width = 49
              Height = 13
              Caption = 'URL Base:'
            end
            object TLabel
              Left = 4
              Top = 53
              Width = 65
              Height = 13
              Caption = 'URL Relativa:'
            end
            object TLabel
              Left = 21
              Top = 84
              Width = 48
              Height = 13
              Caption = 'Opciones:'
            end
            object TLabel
              Left = 17
              Top = 186
              Width = 52
              Height = 13
              Caption = 'Resultado:'
            end
            object e_combineBaseUrl: TEdit
              Left = 72
              Top = 14
              Width = 336
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              MaxLength = 256
              TabOrder = 0
              Text = 'http://www.servidor.com'
            end
            object e_combineRelativaUrl: TEdit
              Left = 72
              Top = 49
              Width = 336
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              MaxLength = 256
              TabOrder = 1
              Text = 'ruta/recurso con caracteres inválidos.html?opción=valor'
            end
            object CombineFlags: TCheckListBox
              Left = 72
              Top = 84
              Width = 336
              Height = 84
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 16
              Items.Strings = (
                'ICU_BROWSER_MODE'
                'ICU_NO_ENCODE'
                'ICU_DECODE'
                'ICU_ENCODE_PERCENT'
                'ICU_ENCODE_SPACES_ONLY')
              Style = lbOwnerDrawFixed
              TabOrder = 2
            end
            object e_combineResult: TEdit
              Left = 72
              Top = 182
              Width = 336
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              MaxLength = 256
              ReadOnly = True
              TabOrder = 3
            end
            inline CombineUrlFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              TabOrder = 4
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
          end
          object ts_crack: TTabSheet
            Caption = 'InternetCrackUrl'
            ImageIndex = 2
            object TLabel
              Left = 5
              Top = 85
              Width = 52
              Height = 13
              Caption = 'Resultado:'
            end
            object TLabel
              Left = 34
              Top = 18
              Width = 23
              Height = 13
              Caption = 'URL:'
            end
            object TLabel
              Left = 9
              Top = 53
              Width = 48
              Height = 13
              Caption = 'Opciones:'
            end
            object lv_components: TListView
              Left = 64
              Top = 85
              Width = 344
              Height = 115
              Anchors = [akLeft, akTop, akRight, akBottom]
              Columns = <
                item
                  Caption = 'Componente'
                  Width = 125
                end
                item
                  AutoSize = True
                  Caption = 'Valor'
                end>
              ColumnClick = False
              TabOrder = 3
              ViewStyle = vsReport
              OnEditing = lv_createEditing
            end
            object CrackFlags: TCheckListBox
              Left = 64
              Top = 49
              Width = 344
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Columns = 3
              ItemHeight = 16
              Items.Strings = (
                'ICU_DECODE'
                'ICU_ESCAPE')
              Style = lbOwnerDrawFixed
              TabOrder = 2
            end
            inline CrackUrlFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
            object e_crackUrl: TEdit
              Left = 64
              Top = 14
              Width = 344
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              MaxLength = 256
              TabOrder = 1
              Text = 
                'http://juancín:contraseña@www.servidor.com/ruta/recurso%20con%20' +
                'caracteres%20inv%E1lidos.html?opción=valor'
            end
          end
          object ts_create: TTabSheet
            Caption = 'InternetCreateUrl'
            ImageIndex = 3
            object TLabel
              Left = 7
              Top = 14
              Width = 70
              Height = 13
              Caption = 'Componentes:'
            end
            object TLabel
              Left = 29
              Top = 108
              Width = 48
              Height = 13
              Anchors = [akLeft, akBottom]
              Caption = 'Opciones:'
            end
            object TLabel
              Left = 25
              Top = 144
              Width = 52
              Height = 13
              Anchors = [akLeft, akBottom]
              Caption = 'Resultado:'
            end
            inline CreateUrlFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              inherited p_pie: TPanel
                Width = 416
                inherited l_retorno: TLabel
                  Width = 283
                end
                inherited Bevel1: TBevel
                  Width = 404
                end
                inherited b_ejecutar: TButton
                  Left = 344
                end
              end
            end
            object lv_create: TListView
              Left = 81
              Top = 14
              Width = 327
              Height = 75
              Anchors = [akLeft, akTop, akRight, akBottom]
              Columns = <
                item
                  Caption = 'Componente'
                  Width = 125
                end
                item
                  AutoSize = True
                  Caption = 'Valor'
                end>
              ColumnClick = False
              HideSelection = False
              Items.Data = {
                360100000700000000000000FFFFFFFFFFFFFFFF010000000000000006536368
                656D65046874747000000000FFFFFFFFFFFFFFFF010000000000000004486F73
                74107777772E7365727669646F722E636F6D00000000FFFFFFFFFFFFFFFF0100
                00000000000004506F727402383000000000FFFFFFFFFFFFFFFF010000000000
                000008557365726E616D65076A75616E63ED6E00000000FFFFFFFFFFFFFFFF01
                000000000000000850617373776F72640A636F6E7472617365F16100000000FF
                FFFFFFFFFFFFFF010000000000000004506174682B2F727574612F7265637572
                736F20636F6E206361726163746572657320696E76E16C69646F732E68746D6C
                00000000FFFFFFFFFFFFFFFF01000000000000000545787472610D3F6F706369
                F36E3D76616C6F72FFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              RowSelect = True
              TabOrder = 1
              ViewStyle = vsReport
              OnDblClick = lv_createDblClick
              OnEditing = lv_createEditing
            end
            object CreateFlags: TCheckListBox
              Left = 81
              Top = 104
              Width = 327
              Height = 21
              Anchors = [akLeft, akRight, akBottom]
              Columns = 3
              ItemHeight = 16
              Items.Strings = (
                'ICU_ESCAPE')
              Style = lbOwnerDrawFixed
              TabOrder = 2
            end
            object e_createResult: TEdit
              Left = 81
              Top = 140
              Width = 327
              Height = 21
              Anchors = [akLeft, akRight, akBottom]
              MaxLength = 256
              ReadOnly = True
              TabOrder = 3
            end
          end
        end
      end
      object ts_conexion: TTabSheet
        ImageIndex = 1
        object pc_conexion: TPageControl
          Left = 2
          Top = 6
          Width = 424
          Height = 278
          ActivePage = ts_network
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object ts_network: TTabSheet
            Caption = 'IsNetworkAlive'
            object TLabel
              Left = 12
              Top = 26
              Width = 138
              Height = 13
              Caption = 'Tipo de conexión a detectar:'
            end
            object TLabel
              Left = 13
              Top = 116
              Width = 32
              Height = 13
              Caption = 'Notas:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object TLabel
              Left = 32
              Top = 136
              Width = 362
              Height = 13
              Caption = 
                'Esta función posiblemente retorne un valor incorrecto detrás de ' +
                'un firewall.'
              WordWrap = True
            end
            object TLabel
              Left = 32
              Top = 164
              Width = 365
              Height = 26
              AutoSize = False
              Caption = 
                'La función reside en la librería sensapi.dll, que estará disponi' +
                'ble con Internet Explorer 5 o superior.'
              WordWrap = True
            end
            inline NetworkAliveFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
            object NAFlags: TCheckListBox
              Left = 11
              Top = 50
              Width = 397
              Height = 47
              TabStop = False
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 16
              Items.Strings = (
                'NETWORK_ALIVE_LAN'
                'NETWORK_ALIVE_WAN')
              Style = lbOwnerDrawFixed
              TabOrder = 1
            end
          end
          object ts_destination: TTabSheet
            Caption = 'IsDestinationReachable'
            ImageIndex = 1
            object TLabel
              Left = 16
              Top = 43
              Width = 138
              Height = 13
              Caption = 'Tipo de conexión a detectar:'
            end
            object TLabel
              Left = 16
              Top = 15
              Width = 23
              Height = 13
              Caption = 'URL:'
            end
            object TLabel
              Left = 16
              Top = 112
              Width = 90
              Height = 13
              Caption = 'Velocidad entrada:'
            end
            object TLabel
              Left = 192
              Top = 112
              Width = 79
              Height = 13
              Caption = 'Velocidad salida:'
            end
            object l_inspeed: TLabel
              Left = 115
              Top = 112
              Width = 70
              Height = 13
              AutoSize = False
              Caption = '? KB/s.'
            end
            object l_outspeed: TLabel
              Left = 291
              Top = 112
              Width = 96
              Height = 13
              AutoSize = False
              Caption = '? KB/s.'
            end
            object TLabel
              Left = 13
              Top = 141
              Width = 32
              Height = 13
              Caption = 'Notas:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object TLabel
              Left = 32
              Top = 160
              Width = 362
              Height = 13
              Caption = 
                'Esta función posiblemente retorne un valor incorrecto detrás de ' +
                'un firewall.'
              WordWrap = True
            end
            object TLabel
              Left = 32
              Top = 180
              Width = 365
              Height = 26
              AutoSize = False
              Caption = 
                'La función reside en la librería sensapi.dll, que estará disponi' +
                'ble con Internet Explorer 5 o superior.'
              WordWrap = True
            end
            inline DestinationFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
            object DRFlags: TCheckListBox
              Left = 16
              Top = 62
              Width = 397
              Height = 38
              TabStop = False
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 16
              Items.Strings = (
                'NETWORK_ALIVE_LAN'
                'NETWORK_ALIVE_WAN')
              Style = lbOwnerDrawFixed
              TabOrder = 1
            end
            object e_UrlDR: TEdit
              Left = 48
              Top = 11
              Width = 349
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
              Text = 'http://www.grupoalbor.com'
            end
          end
          object ts_attempt: TTabSheet
            Caption = 'InternetAttemptConnect'
            ImageIndex = 2
            object TLabel
              Left = 0
              Top = 0
              Width = 208
              Height = 16
              Align = alClient
              Alignment = taCenter
              Caption = 'Esta función no tiene parámetros.'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              Layout = tlCenter
              WordWrap = True
            end
            inline AttemptFrame: TEjecutarFrame
              Top = 206
              Width = 404
              Align = alBottom
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
          end
          object ts_connected: TTabSheet
            Caption = 'InternetGetConnectedState'
            ImageIndex = 3
            object TLabel
              Left = 11
              Top = 16
              Width = 85
              Height = 13
              Caption = 'Tipo de conexión:'
            end
            object TLabel
              Left = 24
              Top = 178
              Width = 325
              Height = 13
              Caption = 
                'Esta función sólo está disponible con Internet Explorer 4 o supe' +
                'rior.'
            end
            object TLabel
              Left = 11
              Top = 160
              Width = 32
              Height = 13
              Caption = 'Notas:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            inline ConnectedFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              TabOrder = 1
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
            object ConnectedFlags: TCheckListBox
              Left = 11
              Top = 38
              Width = 397
              Height = 100
              TabStop = False
              OnClickCheck = ConnectedFlagsClickCheck
              Anchors = [akLeft, akTop, akRight]
              Color = clMenu
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 16
              Items.Strings = (
                'INTERNET_CONNECTION_CONFIGURED'
                'INTERNET_CONNECTION_LAN'
                'INTERNET_CONNECTION_MODEM'
                'INTERNET_CONNECTION_OFFLINE'
                'INTERNET_CONNECTION_PROXY'
                'INTERNET_CONNECTION_RAS_INSTALLED')
              ParentFont = False
              Style = lbOwnerDrawFixed
              TabOrder = 0
            end
          end
          object ts_goonline: TTabSheet
            Caption = 'InternetGoOnline'
            ImageIndex = 4
            object TLabel
              Left = 24
              Top = 23
              Width = 23
              Height = 13
              Caption = 'URL:'
            end
            object TLabel
              Left = 8
              Top = 61
              Width = 32
              Height = 13
              Caption = 'Notas:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            inline GoOnlineFrame: TEjecutarFrame
              Top = 206
              Width = 416
              Align = alBottom
              TabOrder = 1
              inherited p_pie: TPanel
                Width = 404
                inherited l_retorno: TLabel
                  Width = 271
                end
                inherited Bevel1: TBevel
                  Width = 392
                end
                inherited b_ejecutar: TButton
                  Left = 332
                end
              end
            end
            object e_goonline: TEdit
              Left = 56
              Top = 19
              Width = 349
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
              Text = 'http://www.grupoalbor.com'
            end
            object m_notas: TMemo
              Left = 16
              Top = 80
              Width = 393
              Height = 124
              TabStop = False
              Anchors = [akLeft, akTop, akRight, akBottom]
              BorderStyle = bsNone
              Color = clBtnFace
              Lines.Strings = (
                
                  'Para probar este ejemplo debemos abrir un programa de gestione l' +
                  'a bandera '
                
                  '"Trabajar sin conexión" (como Internet Explorer o Outlook Expres' +
                  's) y marcar '
                'dicha opción en el menú Archivo.'
                ''
                
                  'Después de hacer clic en el botón Ejecutar, volvemos al menú Arc' +
                  'hivo del '
                
                  'programa y veremos como la opción "Trabajar sin conexión" está o' +
                  'tra vez '
                'desmarcada.'
                ''
                
                  'Esta función sólo está disponible con Internet Explorer 4 o supe' +
                  'rior.')
              ReadOnly = True
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  object p_aux: TPanel
    Left = 127
    Top = 149
    Width = 6
    Height = 24
    BevelOuter = bvNone
    TabOrder = 1
  end
  object acciones: TActionList
    Left = 8
    Top = 260
    object InetCanonicalizeUrl: TAction
      Category = 'URL'
      Caption = 'InternetCanonicalizeUrl'
      OnExecute = InetCanonicalizeUrlExecute
    end
    object InetCombineUrl: TAction
      Category = 'URL'
      Caption = 'InternetCombineUrl'
      OnExecute = InetCombineUrlExecute
    end
    object InetCrackUrl: TAction
      Category = 'URL'
      Caption = 'InternetCrackUrl'
      OnExecute = InetCrackUrlExecute
    end
    object InetCreateUrl: TAction
      Category = 'URL'
      Caption = 'InternetCreateUrl'
      OnExecute = InetCreateUrlExecute
    end
    object InetNetworkAlive: TAction
      Category = 'Conexión'
      Caption = 'InetNetworkAlive'
      OnExecute = InetNetworkAliveExecute
    end
    object InetDestinationReachable: TAction
      Category = 'Conexión'
      Caption = 'InetDestinationReachable'
      OnExecute = InetDestinationReachableExecute
    end
    object InetAttemptConnect: TAction
      Category = 'Conexión'
      Caption = 'InetAttemptConnect'
      OnExecute = InetAttemptConnectExecute
    end
    object InetGetConnectedState: TAction
      Category = 'Conexión'
      Caption = 'InetGetConnectedState'
      OnExecute = InetGetConnectedStateExecute
    end
    object InetGoOnline: TAction
      Category = 'Conexión'
      Caption = 'InetGoOnline'
      OnExecute = InetGoOnlineExecute
    end
  end
end
