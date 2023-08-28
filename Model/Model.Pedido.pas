unit Model.Pedido;

interface

uses
  Controller.Connection,
  FireDAC.Comp.Client,
  SysUtils,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  System.Classes,
  System.Generics.Collections,
  Data.DB;

type
  TItemPedido = class(TObject)
  private
    FCodigo: Integer;
    FCodProduto: String;
    FNumPedido: Integer;
    FQuantidade: Integer;
    FValorUnitario: Currency;
    FTotalItem: Currency;

    procedure Inserir();
    procedure Alterar();
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property CodProduto: String read FCodProduto write FCodProduto;
    property NumPedido: Integer read FNumPedido write FNumPedido;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property TotalItem: Currency read FTotalItem;

    procedure Gravar();
    procedure Deletar();
    procedure Totalizar();

    constructor Create(ACodigo: Integer); overload;
  end;

  TPedido = class(TObject)
  private
    FNumPedido: Integer;
    FTotalPedido: Currency;
    FItens: TObjectList<TItemPedido>;

    procedure Inserir();
    procedure Alterar();
  public
    property NumPedido: Integer read FNumPedido write FNumPedido;
    property ValorTotal: Currency read FTotalPedido;
    property Itens: TObjectList<TItemPedido> read FItens write FItens;

    procedure Gravar();
    procedure Deletar();
    procedure Totalizar();

    constructor Create(ACodigo: Integer); overload;
    constructor Create(); overload;
  end;
implementation

{ TItemPedido }

procedure TItemPedido.Alterar;
var
  TbItemPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItemPedido := Conexao.GerarQuery();
  Conexao.Conectar();

  TbItemPedido.Transaction.StartTransaction();
  try
    TbItemPedido.SQL.Add('UPDATE itens SET ');
    TbItemPedido.SQL.Add('CodProduto = :CodProduto,');
    TbItemPedido.SQL.Add('NumPedido = :NumPedido,');
    TbItemPedido.SQL.Add('Quantidade = :Quantidade,');
    TbItemPedido.SQL.Add('ValorUnitario = :ValorUnitario,');
    TbItemPedido.SQL.Add('ValorTotal = :ValorTotal');
    TbItemPedido.SQL.Add('WHERE CodItem = :CodItem;');
    TbItemPedido.Transaction.Commit();

    TbItemPedido.ParamByName('CodProduto').AsString      := Self.CodProduto;
    TbItemPedido.ParamByName('NumPedido').AsInteger      := Self.FNumPedido;
    TbItemPedido.ParamByName('Quantidade').AsInteger     := Self.Quantidade;
    TbItemPedido.ParamByName('ValorUnitario').AsCurrency := Self.ValorUnitario;
    TbItemPedido.ParamByName('ValorTotal').AsCurrency    := Self.TotalItem;
    TbItemPedido.ParamByName('CodItem').AsCurrency       := Self.Codigo;

    TbItemPedido.ExecSQL();
    TbItemPedido.Transaction.Commit();
  except
    TbItemPedido.Transaction.Rollback();
  end;

  FreeAndNil(TbItemPedido);
end;

constructor TItemPedido.Create(ACodigo: Integer);
var
  TbItemPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItemPedido := Conexao.GerarQuery();
  Conexao.Conectar();

  TbItemPedido.SQL.Text := 'SELECT * FROM Itens WHERE CodItem = ' + IntToStr(ACodigo);
  TbItemPedido.Open();

  Self.FCodigo        := TbItemPedido.FieldByName('CodItem').AsInteger;
  Self.FCodProduto    := TbItemPedido.FieldByName('CodProduto').AsString;
  Self.FNumPedido     := TbItemPedido.FieldByName('NumPedido').AsInteger;
  Self.FQuantidade    := TbItemPedido.FieldByName('Quantidade').AsInteger;
  Self.FValorUnitario := TbItemPedido.FieldByName('ValorUnitario').AsCurrency;
  Self.FTotalItem     := TbItemPedido.FieldByName('ValorTotal').AsCurrency;

  FreeAndNil(TbItemPedido);
end;

procedure TItemPedido.Deletar;
var
  TbItemPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItemPedido := Conexao.GerarQuery();
  Conexao.Conectar();

  TbItemPedido.Transaction.StartTransaction();
  try
    TbItemPedido.SQL.Text := 'DELETE FROM Itens WHERE CodItem = ' + IntToStr(Self.Codigo);
    TbItemPedido.ExecSQL();

    TbItemPedido.Transaction.Commit();
  except
    TbItemPedido.Transaction.Rollback();
  end;

  FreeAndNil(TbItemPedido);
end;

procedure TItemPedido.Gravar;
begin
  Self.Totalizar();

  if Self.FCodigo > 0 then
  begin
    Self.Alterar()
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TItemPedido.Inserir;
var
  TbItemPedido: TFDQuery;
  TbItemUltimoID: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItemPedido := Conexao.GerarQuery();
  TbItemUltimoID := Conexao.GerarQuery();
  Conexao.Conectar();

  TbItemPedido.Transaction.StartTransaction();
  try
    TbItemUltimoID.SQL.Add('SELECT MAX(NumPedido) AS MAXID FROM Pedidos');
    TbItemUltimoID.Open();

    TbItemPedido.SQL.Add('INSERT INTO Itens (CodItem, CodProduto, NumPedido, Quantidade, ValorUnitario, ValorTotal) Values (');
    TbItemPedido.SQL.Add(':CodItem,');
    TbItemPedido.SQL.Add(':CodProduto,');
    TbItemPedido.SQL.Add(':NumPedido,');
    TbItemPedido.SQL.Add(':Quantidade,');
    TbItemPedido.SQL.Add(':ValorUnitario,');
    TbItemPedido.SQL.Add(':TotalItem);');

    TbItemPedido.ParamByName('CodProduto').AsString      := Self.CodProduto;
    TbItemPedido.ParamByName('NumPedido').AsInteger      := Self.FNumPedido;
    TbItemPedido.ParamByName('Quantidade').AsInteger     := Self.Quantidade;
    TbItemPedido.ParamByName('ValorUnitario').AsCurrency := Self.ValorUnitario;
    TbItemPedido.ParamByName('TotalItem').AsCurrency     := Self.TotalItem;
    TbItemPedido.ParamByName('CodItem').AsInteger        := TbItemUltimoID.FieldByName('MAXID').AsInteger + 1;

    TbItemPedido.ExecSQL();
    TbItemPedido.Transaction.Commit();

    Self.FCodigo := TbItemUltimoID.FieldByName('MAXID').AsInteger + 1;
  except
    TbItemPedido.Transaction.Rollback();
  end;

  FreeAndNil(TbItemPedido);
end;

procedure TItemPedido.Totalizar;
begin
  Self.FTotalItem := Self.FValorUnitario * Self.FQuantidade;
end;

{ TPedido }

procedure TPedido.Alterar;
var
  TbPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbPedido := Conexao.GerarQuery();
  Conexao.Conectar();

  TbPedido.Transaction.StartTransaction();
  try
    TbPedido.SQL.Add('UPDATE Pedidos SET ');
    TbPedido.SQL.Add('ValorTotal = :ValorTotal');
    TbPedido.SQL.Add('WHERE NumPedido = :NumPedido;');

    TbPedido.ParamByName('ValorTotal').AsCurrency := Self.ValorTotal;
    TbPedido.ParamByName('NumPedido').AsInteger := Self.NumPedido;

    TbPedido.ExecSQL();
    TbPedido.Transaction.Commit();
  except
    TbPedido.Transaction.Rollback();
  end;

  for var Item in Self.Itens do
  begin
    Item.NumPedido := Self.FNumPedido;
    Item.Gravar();
  end;

  FreeAndNil(TbPedido);
end;

constructor TPedido.Create(ACodigo: Integer);
var
  TbPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbPedido := Conexao.GerarQuery;
  Conexao.Conectar();

  TbPedido.SQL.Text := 'SELECT * FROM Pedidos WHERE NumPedido = ' + IntToStr(ACodigo);
  TbPedido.Open();

  Self.FNumPedido   := TbPedido.FieldByName('NumPedido').AsInteger;
  Self.FTotalPedido := TbPedido.FieldByName('ValorTotal').AsCurrency;

  Self.Itens := TObjectList<TItemPedido>.Create();

  TbPedido.Close();
  TbPedido.SQL.Text := 'SELECT CodItem FROM Itens WHERE NumPedido = ' + IntToStr(ACodigo);
  TbPedido.Open();

  TbPedido.First();
  for var I := 0 to TbPedido.RecordCount - 1 do
  begin
    Self.Itens.Add(TItemPedido.Create(TbPedido.FieldByName('CodItem').AsInteger));
    TbPedido.Next();
  end;

  FreeAndNil(TbPedido);
end;

constructor TPedido.Create;
begin
  Self.Itens    := TObjectList<TItemPedido>.Create();
end;

procedure TPedido.Deletar;
var
  TbPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbPedido := Conexao.GerarQuery();
  Conexao.Conectar();

  for var Item in Self.Itens do
  begin
    Item.Deletar();
  end;

  TbPedido.Transaction.StartTransaction();
  try
    TbPedido.SQL.Text := 'DELETE FROM Pedidos WHERE NumPedido = ' + IntToStr(Self.NumPedido);
    TbPedido.ExecSQL();
    TbPedido.Transaction.Commit();
  except
    TbPedido.Transaction.Rollback();
  end;

  FreeAndNil(TbPedido);
end;

procedure TPedido.Totalizar();
begin
  Self.FTotalPedido := 0;

  for var Item in Self.FItens do
  begin
    if (Item.TotalItem <= 0.001) then
    begin
      Item.Totalizar();
    end;

    Self.FTotalPedido := Self.FTotalPedido + Item.TotalItem;
  end;
end;

procedure TPedido.Gravar;
begin
  Self.Totalizar();

  if Self.FNumPedido > 0 then
  begin
    Self.Alterar()
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TPedido.Inserir;
var
  TbPedido: TFDQuery;
  TbPedidoUltimoID: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbPedidoUltimoID := Conexao.GerarQuery();
  TbPedido := Conexao.GerarQuery();

  Conexao.Conectar();

  TbPedido.Transaction.StartTransaction();
  try
    TbPedidoUltimoID.SQL.Add('SELECT MAX(NumPedido) AS MAXID FROM Pedidos');
    TbPedidoUltimoID.Open();


    TbPedido.SQL.Add('INSERT INTO Pedidos (NumPedido, ValorTotal) Values (');
    TbPedido.SQL.Add(':NumPedido,');
    TbPedido.SQL.Add(':ValorTotal);');

    TbPedido.ParamByName('ValorTotal').AsCurrency := Self.ValorTotal;
    TbPedido.ParamByName('NumPedido').AsInteger   := TbPedidoUltimoID.FieldByName('MAXID').AsInteger + 1;

    TbPedido.ExecSQL();
    TbPedido.Transaction.Commit();

    Self.FNumPedido := TbPedidoUltimoID.FieldByName('MAXID').AsInteger + 1;
  except
    TbPedido.Transaction.Rollback();
  end;

  for var Item in Self.Itens do
  begin
    Item.NumPedido := Self.FNumPedido;
    Item.Gravar();
  end;

  FreeAndNil(TbPedido);
end;

end.
