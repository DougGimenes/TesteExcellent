object FrmProdutos: TFrmProdutos
  Left = 0
  Top = 0
  Caption = 'Produtos'
  ClientHeight = 322
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object DbgProdutos: TDBGrid
    Left = 0
    Top = 41
    Width = 705
    Height = 281
    Align = alClient
    DataSource = DsProdutos
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = DbgProdutosCellClick
    OnDrawColumnCell = DbgProdutosDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'CodigoBarras'
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'd. Barras'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PrecoVenda'
        Title.Alignment = taCenter
        Title.Caption = 'Pre'#231'o de Venda'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Estoque'
        Title.Alignment = taCenter
        Title.Caption = 'Qtde. Estoque'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BtnEditar'
        Title.Alignment = taCenter
        Title.Caption = 'Editar'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BtnExcluir'
        Title.Alignment = taCenter
        Title.Caption = 'Excluir'
        Visible = True
      end>
  end
  object PnlInserir: TPanel
    Left = 0
    Top = 0
    Width = 705
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 675
    object BtnNovoProduto: TButton
      Left = 0
      Top = 10
      Width = 145
      Height = 25
      Caption = 'Incluir Novo Produto'
      TabOrder = 0
      OnClick = BtnNovoProdutoClick
    end
  end
  object DsProdutos: TDataSource
    DataSet = TbProdutos
    Left = 24
    Top = 144
  end
  object TbProdutos: TFDQuery
    SQL.Strings = (
      'SELECT * FROM PRODUTOS')
    Left = 24
    Top = 88
  end
end
