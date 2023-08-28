unit View.Pedidos.Geral;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Controller.Connection,
  Model.Pedido,
  View.Pedidos.Cadastro;

type
  TFrmPedidosGeral = class(TForm)
    DbgPedidos: TDBGrid;
    PnlInserir: TPanel;
    BtnNovoProduto: TButton;
    DsPedidos: TDataSource;
    TbPedidos: TFDQuery;
    TbPedidosNumPedido: TIntegerField;
    TbPedidosValorTotal: TCurrencyField;
    procedure FormCreate(Sender: TObject);
    procedure DbgPedidosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DbgPedidosCellClick(Column: TColumn);
    procedure BtnNovoProdutoClick(Sender: TObject);
  private
    { Private declarations }
    FConexao : TConexao;
    procedure RecarregarTabela();
  public
    { Public declarations }
  end;

var
  FrmPedidosGeral: TFrmPedidosGeral;

implementation

{$R *.dfm}

procedure TFrmPedidosGeral.BtnNovoProdutoClick(Sender: TObject);
var
  FrmNovoPedido: TFrmNovoPedido;
begin
  FrmNovoPedido := TFrmNovoPedido.Create(Self);

  try
    FrmNovoPedido.ShowModal();
  finally
    FreeAndNil(FrmNovoPedido);
  end;

  Self.RecarregarTabela();
end;

procedure TFrmPedidosGeral.DbgPedidosCellClick(Column: TColumn);
begin
  if not (Self.TbPedidos.FieldByName('NumPedido').AsInteger > 0) then
    Exit;

  if Column.FieldName = 'BtnExcluir' then
  begin
    if MessageDlg('Deseja excluir esse pedido?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      with TPedido.Create(Self.TbPedidos.FieldByName('NumPedido').AsInteger) do
      begin
        Deletar();
      end;
    end;
    Self.RecarregarTabela();
  end;
end;

procedure TFrmPedidosGeral.DbgPedidosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.FieldName = 'BtnExcluir' then
  begin
    var Botao: TRect;
    var CorFundo: TColor;

    Self.DbgPedidos.Canvas.FillRect(Rect);
    Botao := Rect;
    InflateRect(Botao, -1, -1);

    DrawFrameControl(DbgPedidos.Canvas.Handle, Botao, 0, 0);
    CorFundo := DbgPedidos.Canvas.Brush.Color;
    Self.DbgPedidos.Canvas.Brush.Color := clBtnFace;

    DrawText(DbgPedidos.Canvas.Handle, 'Excluir', 7, Botao, DT_CENTER);
    Self.DbgPedidos.Canvas.Brush.Color := CorFundo;
  end;
end;

procedure TFrmPedidosGeral.FormCreate(Sender: TObject);
begin
  FConexao := TConexao.ObterInstancia();
  FConexao.Conectar();
  Self.TbPedidos.Connection :=  FConexao;
  Self.TbPedidos.Open();
end;

procedure TFrmPedidosGeral.RecarregarTabela();
begin
  Self.TbPedidos.Close();
  Self.TbPedidos.Open();
end;

end.
