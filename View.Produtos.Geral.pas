unit View.Produtos.Geral;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Async, FireDAC.DApt,
  Controller.Connection,
  Model.Produto, Vcl.StdCtrls,
  View.Produtos.Cadastro;

type
  TFrmProdutos = class(TForm)
    DbgProdutos: TDBGrid;
    PnlInserir: TPanel;
    DsProdutos: TDataSource;
    TbProdutos: TFDQuery;
    BtnNovoProduto: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DbgProdutosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DbgProdutosCellClick(Column: TColumn);
    procedure BtnNovoProdutoClick(Sender: TObject);
  private
    { Private declarations }
    FConexao : TConexao;
    procedure RecarregarTabela();
    procedure EdicaoProduto(ANovo: Boolean);
  public
    { Public declarations }
  end;

var
  FrmProdutos: TFrmProdutos;

implementation

{$R *.dfm}

procedure TFrmProdutos.BtnNovoProdutoClick(Sender: TObject);
begin
  Self.EdicaoProduto(True);
  Self.RecarregarTabela();
end;

procedure TFrmProdutos.DbgProdutosCellClick(Column: TColumn);
begin
  if Trim(Self.TbProdutos.FieldByName('CodigoBarras').AsString) = '' then
    Exit;

  if Column.FieldName = 'BtnEditar' then
  begin
    Self.EdicaoProduto(False);
    Self.RecarregarTabela();
  end;

  if Column.FieldName = 'BtnExcluir' then
  begin
    if MessageDlg('Deseja excluir esse produto?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      with TProduto.Create(Self.TbProdutos.FieldByName('CodigoBarras').AsString) do
      begin 
        Excluir();
      end;
      Self.RecarregarTabela();
    end;
  end;
end;

procedure TFrmProdutos.DbgProdutosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.FieldName = 'BtnEditar' then
  begin
    var Botao: TRect;
    var CorFundo: TColor;

    Self.DbgProdutos.Canvas.FillRect(Rect);
    Botao := Rect;
    InflateRect(Botao, -1, -1);

    DrawFrameControl(DbgProdutos.Canvas.Handle, Botao, 0, 0);
    CorFundo := DbgProdutos.Canvas.Brush.Color;
    Self.DbgProdutos.Canvas.Brush.Color := clBtnFace;

    DrawText(DbgProdutos.Canvas.Handle, 'Editar', 6, Botao, DT_CENTER);
    Self.DbgProdutos.Canvas.Brush.Color := CorFundo;
  end;

  if Column.FieldName = 'BtnExcluir' then
  begin
    var Botao: TRect;
    var CorFundo: TColor;

    Self.DbgProdutos.Canvas.FillRect(Rect);
    Botao := Rect;
    InflateRect(Botao, -1, -1);

    DrawFrameControl(DbgProdutos.Canvas.Handle, Botao, 0, 0);
    CorFundo := DbgProdutos.Canvas.Brush.Color;
    Self.DbgProdutos.Canvas.Brush.Color := clBtnFace;

    DrawText(DbgProdutos.Canvas.Handle, 'Excluir', 7, Botao, DT_CENTER);
    Self.DbgProdutos.Canvas.Brush.Color := CorFundo;
  end;
end;

procedure TFrmProdutos.FormCreate(Sender: TObject);
begin
  FConexao := TConexao.ObterInstancia();
  FConexao.Conectar();
  Self.TbProdutos.Connection :=  FConexao;
  Self.TbProdutos.Open()
end;


procedure TFrmProdutos.RecarregarTabela();
begin
  Self.TbProdutos.Close();
  Self.TbProdutos.Open();
end;

procedure TFrmProdutos.EdicaoProduto(ANovo: Boolean);
var
  FrmProdutoEditar: TFrmProdutosCadastro;
begin
  if ANovo then
  begin
    FrmProdutoEditar := TFrmProdutosCadastro.Create(Self);
  end
  else
  begin
    var ProdutoEnviado: TProduto;
    ProdutoEnviado := TProduto.Create(Self.TbProdutos.FieldByName('CodigoBarras').AsString);
    FrmProdutoEditar := TFrmProdutosCadastro.Create(Self, ProdutoEnviado);
  end;

  try
    FrmProdutoEditar.ShowModal();
  finally
    FreeAndNil(FrmProdutoEditar);
  end;
end;

end.
