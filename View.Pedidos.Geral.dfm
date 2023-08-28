object FrmPedidosGeral: TFrmPedidosGeral
  Left = 0
  Top = 0
  Caption = 'Pedidos'
  ClientHeight = 341
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object DbgPedidos: TDBGrid
    Left = 0
    Top = 41
    Width = 250
    Height = 300
    Align = alClient
    DataSource = DsPedidos
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = DbgPedidosCellClick
    OnDrawColumnCell = DbgPedidosDrawColumnCell
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'NumPedido'
        Title.Alignment = taCenter
        Title.Caption = 'Num. Pedido'
        Width = 80
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'ValorTotal'
        Title.Alignment = taCenter
        Title.Caption = 'Valor Total'
        Width = 80
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
    Width = 250
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 712
    DesignSize = (
      250
      41)
    object BtnNovoProduto: TButton
      Left = 1
      Top = 10
      Width = 248
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Incluir Novo Pedido'
      DisabledImageName = 'BtnNovoPedido'
      TabOrder = 0
      OnClick = BtnNovoProdutoClick
    end
  end
  object DsPedidos: TDataSource
    DataSet = TbPedidos
    Left = 24
    Top = 144
  end
  object TbPedidos: TFDQuery
    SQL.Strings = (
      'SELECT * FROM Pedidos')
    Left = 24
    Top = 88
    object TbPedidosNumPedido: TIntegerField
      FieldName = 'NumPedido'
    end
    object TbPedidosValorTotal: TCurrencyField
      FieldName = 'ValorTotal'
    end
  end
end
