object LoginFrm: TLoginFrm
  Left = 224
  Top = 132
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 119
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 26
    Top = 16
    Width = 39
    Height = 13
    Caption = 'Usuario:'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 57
    Height = 13
    Caption = 'Contraseña:'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 79
    Width = 269
    Height = 10
    Shape = bsTopLine
  end
  object e_user: TEdit
    Left = 72
    Top = 12
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object e_pass: TEdit
    Left = 72
    Top = 44
    Width = 201
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 128
    Top = 89
    Width = 68
    Height = 22
    Caption = 'Aceptar'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 205
    Top = 89
    Width = 68
    Height = 22
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 3
  end
end
