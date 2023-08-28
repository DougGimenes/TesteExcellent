unit View.Pedidos.Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Model.Pedido,
  Model.Produto, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Samples.Spin, Vcl.Mask, Vcl.ExtCtrls;

type
  TFrmNovoPedido = class(TForm)
    BtnCancelar: TButton;
    BtnSalvar: TButton;
    MtbItens: TFDMemTable;
    DsItens: TDataSource;
    DbgItens: TDBGrid;
    MtbItensDescricao: TStringField;
    MtbItensCodBarras: TStringField;
    MtbItensQuantidade: TIntegerField;
    MtbItensCodigo: TIntegerField;
    EdtCodBarras: TLabeledEdit;
    LblQuantidade: TLabel;
    SedQuantidade: TSpinEdit;
    BtnInserir: TButton;
    MtbItensValorUnitario: TCurrencyField;
    MtbItensValorTotal: TCurrencyField;
    procedure BtnInserirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    FPedido: TPedido;
    procedure RecarregarItens();
  public
    { Public declarations }
  end;

var
  FrmNovoPedido: TFrmNovoPedido;

implementation

{$R *.dfm}

procedure TFrmNovoPedido.BtnCancelarClick(Sender: TObject);
begin
  Self.Close();
end;

procedure TFrmNovoPedido.BtnInserirClick(Sender: TObject);
var
  NovoItem: TItemPedido;
  Produto: TProduto;
begin
  NovoItem := TItemPedido.Create();
  Produto  := TProduto.Create(Self.EdtCodBarras.Text);

  NovoItem.CodProduto    := Self.EdtCodBarras.Text;
  NovoItem.ValorUnitario := Produto.PrecoVenda;
  NovoItem.Quantidade    := Self.SedQuantidade.Value;
  NovoItem.Totalizar();

  Self.FPedido.Itens.Add(NovoItem);

  Self.RecarregarItens;

  Self.EdtCodBarras.Text := '';
  Self.SedQuantidade.Value := 1;
end;

procedure TFrmNovoPedido.BtnSalvarClick(Sender: TObject);
begin
  Self.FPedido.Gravar();
  Self.Close();
end;

procedure TFrmNovoPedido.FormCreate(Sender: TObject);
begin
  Self.FPedido := TPedido.Create();
  Self.MtbItens.Open();
end;

procedure TFrmNovoPedido.RecarregarItens();
begin
  Self.MtbItens.EmptyDataSet();
  for var Item in FPedido.Itens do
  begin
    Self.MtbItens.Append();
    Self.MtbItensCodigo.AsInteger         := Item.Codigo;
    Self.MtbItensCodBarras.AsString       := Item.CodProduto;
    Self.MtbItensDescricao.AsString       := TProduto.Create(Item.CodProduto).Descricao;
    Self.MtbItensValorUnitario.AsCurrency := Item.ValorUnitario;
    Self.MtbItensValorTotal.AsCurrency    := Item.TotalItem;
    Self.MtbItensQuantidade.AsInteger     := Item.Quantidade;
    Self.MtbItens.Post();
  end;
end;

end.
