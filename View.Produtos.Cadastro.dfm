object FrmProdutosCadastro: TFrmProdutosCadastro
  Left = 0
  Top = 0
  Caption = 'FrmProdutosCadastro'
  ClientHeight = 258
  ClientWidth = 589
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object LblEstoque: TLabel
    Left = 143
    Top = 77
    Width = 42
    Height = 15
    Caption = 'Estoque'
  end
  object ImgFotoProduto: TImage
    Left = 352
    Top = 77
    Width = 153
    Height = 132
    Stretch = True
  end
  object EdtCodBarras: TLabeledEdit
    Left = 16
    Top = 48
    Width = 121
    Height = 23
    EditLabel.Width = 90
    EditLabel.Height = 15
    EditLabel.Caption = 'C'#243'digo de Barras'
    TabOrder = 0
    Text = ''
  end
  object EdtDescricao: TLabeledEdit
    Left = 143
    Top = 48
    Width = 410
    Height = 23
    EditLabel.Width = 51
    EditLabel.Height = 15
    EditLabel.Caption = 'Descri'#231#227'o'
    TabOrder = 1
    Text = ''
  end
  object SedEstoque: TSpinEdit
    Left = 143
    Top = 96
    Width = 121
    Height = 24
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object EdtPrecoVenda: TLabeledEdit
    Left = 16
    Top = 96
    Width = 118
    Height = 23
    EditLabel.Width = 81
    EditLabel.Height = 15
    EditLabel.Caption = 'Pre'#231'o de Venda'
    TabOrder = 2
    Text = ''
    OnExit = EdtPrecoVendaExit
  end
  object BtnSalvar: TButton
    Left = 16
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 4
    OnClick = BtnSalvarClick
  end
  object BtnCancelar: TButton
    Left = 97
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 5
    OnClick = BtnCancelarClick
  end
  object BtnIncluirImagem: TButton
    Left = 305
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Incluir Img.'
    TabOrder = 6
    OnClick = BtnIncluirImagemClick
  end
  object BtnAlterarImagem: TButton
    Left = 386
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Alterar Img.'
    TabOrder = 7
    OnClick = BtnAlterarImagemClick
  end
  object BtnExcluirImagem: TButton
    Left = 467
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Excluir Img.'
    TabOrder = 8
    OnClick = BtnExcluirImagemClick
  end
  object BtnProximaImg: TButton
    Left = 511
    Top = 136
    Width = 18
    Height = 25
    Caption = '>'
    TabOrder = 9
    OnClick = BtnProximaImgClick
  end
  object BtnImgAnterior: TButton
    Left = 328
    Top = 136
    Width = 18
    Height = 25
    Caption = '<'
    TabOrder = 10
    OnClick = BtnImgAnteriorClick
  end
  object DlgImagem: TOpenDialog
    Left = 288
    Top = 152
  end
end
