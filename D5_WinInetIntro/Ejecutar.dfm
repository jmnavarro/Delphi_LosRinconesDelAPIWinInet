object EjecutarFrame: TEjecutarFrame
  Left = 0
  Top = 0
  Width = 333
  Height = 44
  VertScrollBar.Visible = False
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object p_pie: TPanel
    Left = 0
    Top = 3
    Width = 333
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BevelWidth = 2
    BorderWidth = 3
    TabOrder = 0
    object l_retorno2: TLabel
      Left = 7
      Top = 19
      Width = 43
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Retorno:'
    end
    object l_retorno: TLabel
      Left = 55
      Top = 19
      Width = 200
      Height = 13
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      Caption = 'Pendiente de ejecutar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 6
      Top = 2
      Width = 321
      Height = 12
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object b_ejecutar: TButton
      Left = 261
      Top = 12
      Width = 67
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Ejecutar'
      TabOrder = 0
      OnClick = Execute
    end
  end
end
