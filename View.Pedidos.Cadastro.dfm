object FrmNovoPedido: TFrmNovoPedido
  Left = 0
  Top = 0
  Caption = 'Novo Pedido'
  ClientHeight = 442
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    597
    442)
  TextHeight = 15
  object LblQuantidade: TLabel
    Left = 383
    Top = 362
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  object BtnCancelar: TButton
    Left = 89
    Top = 409
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 0
    OnClick = BtnCancelarClick
  end
  object BtnSalvar: TButton
    Left = 8
    Top = 409
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 1
    OnClick = BtnSalvarClick
  end
  object DbgItens: TDBGrid
    Left = 8
    Top = 8
    Width = 581
    Height = 353
    Anchors = [akLeft, akTop, akRight]
    DataSource = DsItens
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CodBarras'
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'd. Barras'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ValorUnitario'
        Title.Alignment = taCenter
        Title.Caption = 'Vlr. Unit'#225'rio'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ValorTotal'
        Title.Alignment = taCenter
        Title.Caption = 'Vlr. Total'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantidade'
        Title.Alignment = taCenter
        Width = 80
        Visible = True
      end>
  end
  object EdtCodBarras: TLabeledEdit
    Left = 8
    Top = 380
    Width = 369
    Height = 23
    EditLabel.Width = 57
    EditLabel.Height = 15
    EditLabel.Caption = 'C'#243'd Barras'
    TabOrder = 3
    Text = ''
  end
  object SedQuantidade: TSpinEdit
    Left = 383
    Top = 380
    Width = 121
    Height = 24
    MaxValue = 1
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object BtnInserir: TButton
    Left = 510
    Top = 379
    Width = 79
    Height = 25
    Caption = 'Inserir'
    TabOrder = 5
    OnClick = BtnInserirClick
  end
  object MtbItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 24
    Top = 64
    object MtbItensDescricao: TStringField
      FieldName = 'Descricao'
      Size = 100
    end
    object MtbItensCodBarras: TStringField
      FieldName = 'CodBarras'
      Size = 13
    end
    object MtbItensQuantidade: TIntegerField
      FieldName = 'Quantidade'
    end
    object MtbItensCodigo: TIntegerField
      FieldName = 'Codigo'
    end
    object MtbItensValorUnitario: TCurrencyField
      FieldName = 'ValorUnitario'
    end
    object MtbItensValorTotal: TCurrencyField
      FieldName = 'ValorTotal'
    end
  end
  object DsItens: TDataSource
    DataSet = MtbItens
    Left = 24
    Top = 120
  end
end
