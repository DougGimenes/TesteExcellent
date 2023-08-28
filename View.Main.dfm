object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'TesteExcellent'
  ClientHeight = 81
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object BtnProdutos: TButton
    Left = 0
    Top = 0
    Width = 90
    Height = 81
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Produtos'
    TabOrder = 0
    OnClick = BtnProdutosClick
  end
  object BtnPedidos: TButton
    Left = 95
    Top = 0
    Width = 90
    Height = 81
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Pedidos'
    TabOrder = 1
    OnClick = BtnPedidosClick
    ExplicitLeft = 91
  end
end
