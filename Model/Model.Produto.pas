unit Model.Produto;

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
  TImagemProduto = class(TObject)
  private
    FIdImagem: Integer;
    FImagem: TMemoryStream;
    FCodigoBarras: String;

    procedure Inserir();
    procedure Editar();

  public
    property IdImagem: Integer read FIdImagem;
    property CodigoBarras: String read FCodigoBarras write FCodigoBarras;
    property Imagem: TMemoryStream read FImagem write FImagem;

    constructor Create(AIdImagem : Integer); overload;
    constructor Create(); overload;

    procedure Gravar();
    procedure Excluir();
  end;

  TProduto = class(TObject)
  private
    FCodigoBarras: String;
    FDescricao: String;
    FPrecoVenda: Currency;
    FEstoque: Integer;
    FListaImagens: TObjectlist<TImagemProduto>;

    procedure Inserir();
    procedure Editar();

  public
    property CodigoBarras: String read FCodigoBarras write FCodigoBarras;
    property Descricao: String read FDescricao write FDescricao;
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
    property Estoque: Integer read FEstoque write FEstoque;
    property ListaImagens: TObjectlist<TImagemProduto> read FListaImagens write FListaImagens;

    constructor Create(ACodigoBarras : String); overload;
    constructor Create(); overload;

    procedure Gravar();
    procedure Excluir();
  end;

implementation

{ TProduto }


constructor TProduto.Create();
begin
  inherited Create();
  Self.FListaImagens := TObjectList<TImagemProduto>.Create(True);
end;

constructor TProduto.Create(ACodigoBarras : String);
var
  TbProduto: TFDQuery;
  TbImagens: TFDQuery;
  Conexao : TConexao;
begin
  inherited Create();
  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  TbImagens := Conexao.GerarQuery();
  Conexao.Conectar();

  TbProduto.SQL.Text := 'SELECT * FROM Produtos WHERE CodigoBarras = ' + ACodigoBarras;
  TbProduto.Open();

  Self.FCodigoBarras := TbProduto.FieldByName('CodigoBarras').AsString;
  Self.FDescricao    := TbProduto.FieldByName('Descricao').AsString;
  Self.FPrecoVenda   := TbProduto.FieldByName('PrecoVenda').AsCurrency;
  Self.FEstoque      := TbProduto.FieldByName('Estoque').AsInteger;

  TbImagens.SQL.Text := 'SELECT IdImagem FROM ImagensProdutos WHERE CodigoBarras = ' + ACodigoBarras;
  TbImagens.Open();

  Self.FListaImagens := TObjectList<TImagemProduto>.Create(True);
  for var I := 0 to TbImagens.RecordCount - 1 do
  begin
    Self.FListaImagens.Add(TImagemProduto.Create(TbImagens.FieldByName('IDIMAGEM').AsInteger));
    TbImagens.Next();
  end;
    

  FreeAndNil(TbProduto);
  FreeAndNil(TbImagens);
end;

procedure TProduto.Gravar();
var
  TbProduto: TFDQuery;
  Conexao : TConexao;
begin
  if Trim(Self.CodigoBarras) = '' then
    Exit;

  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  TbProduto.SQL.Text := 'SELECT * FROM Produtos WHERE CodigoBarras = ' + Self.CodigoBarras;
  TbProduto.Open();

  if TbProduto.RecordCount = 0 then
  begin
    Self.Inserir();
  end
  else
  begin
    Self.Editar();
  end;
end;

procedure TProduto.Inserir();
var
  TbProduto: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbProduto.Transaction.StartTransaction();
  try
    TbProduto.SQL.Add('INSERT INTO PRODUTOS(CODIGOBARRAS, DESCRICAO, PRECOVENDA, ESTOQUE) Values(');
    TbProduto.SQL.Add(':CODIGOBARRAS,');
    TbProduto.SQL.Add(':DESCRICAO,');
    TbProduto.SQL.Add(':PRECOVENDA,');
    TbProduto.SQL.Add(':ESTOQUE);');

    TbProduto.ParamByName('CODIGOBARRAS').AsString := Self.CodigoBarras;
    TbProduto.ParamByName('DESCRICAO').AsString    := Self.Descricao;
    TbProduto.ParamByName('PRECOVENDA').AsCurrency    := Self.PrecoVenda;
    TbProduto.ParamByName('ESTOQUE').AsInteger     := Self.Estoque;

    TbProduto.ExecSQl();
    TbProduto.Transaction.Commit();
  except
    TbProduto.Transaction.Rollback();
  end;

  for var I := 0 to Self.ListaImagens.Count - 1 do
  begin
    Self.FListaImagens[I].FCodigoBarras := Self.CodigoBarras;
    Self.ListaImagens[I].Gravar();
  end;


  FreeAndNil(TbProduto);
end;

procedure TProduto.Editar();
var
  TbProduto: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbProduto.Transaction.StartTransaction();
  try
    TbProduto.SQL.Add('UPDATE PRODUTOS SET');
    TbProduto.SQL.Add('DESCRICAO = :DESCRICAO,');
    TbProduto.SQL.Add('PRECOVENDA = :PRECOVENDA,');
    TbProduto.SQL.Add('ESTOQUE = :ESTOQUE');
    TbProduto.SQL.Add('WHERE CODIGOBARRAS = :CODIGOBARRAS');

    TbProduto.ParamByName('CODIGOBARRAS').AsString := Self.CodigoBarras;
    TbProduto.ParamByName('DESCRICAO').AsString    := Self.Descricao;
    TbProduto.ParamByName('PRECOVENDA').AsCurrency    := Self.PrecoVenda;
    TbProduto.ParamByName('ESTOQUE').AsInteger     := Self.Estoque;

    TbProduto.ExecSQl();
    TbProduto.Transaction.Commit();
  except
    TbProduto.Transaction.Rollback();
  end;

  for var I := 0 to Self.ListaImagens.Count - 1 do
  begin
    Self.FListaImagens[I].FCodigoBarras := Self.CodigoBarras;
    Self.ListaImagens[I].Gravar();
  end;


  FreeAndNil(TbProduto);
end;

procedure TProduto.Excluir();
var
  TbProduto: TFDQuery;
  TbImagens: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  TbProduto.SQL.Text := 'DELETE FROM Produtos WHERE CodigoBarras = ' + Self.CodigoBarras;
  TbProduto.ExecSQL;

  TbImagens :=  Conexao.GerarQuery();
  TbImagens.SQL.Text := 'DELETE FROM ImagensProdutos WHERE CodigoBarras = ' + Self.CodigoBarras;
end;

{ TImagemProduto }

constructor TImagemProduto.Create(AIdImagem: Integer);
var
  TbImagens: TFDQuery;
  Conexao : TConexao;
begin
  inherited Create();
  Conexao := TConexao.ObterInstancia();
  TbImagens := Conexao.GerarQuery();
  Conexao.Conectar();

  TbImagens.SQL.Text := 'SELECT * FROM ImagensProdutos WHERE IdImagem = ' + IntToStr(AIdImagem);
  TbImagens.Open();

  Self.FCodigoBarras := TbImagens.FieldByName('CodigoBarras').AsString;
  Self.FIdImagem     := TbImagens.FieldByName('IdImagem').AsInteger;

  Self.FImagem := TMemoryStream.Create();
  Self.FImagem.LoadFromStream(TbImagens.CreateBlobStream(TbImagens.FieldByName('Imagem') as TBlobField, bmread));

  FreeAndNil(TbImagens);
end;

procedure TImagemProduto.Gravar;
begin
  if Self.IdImagem > 0 then
  begin
    Self.Editar();
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TImagemProduto.Inserir;
var
  TbImagens: TFDQuery;
  TbImagensUltimoID: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbImagens :=  Conexao.GerarQuery();
  TbImagensUltimoID := Conexao.GerarQuery();
  Conexao.Conectar();

  TbImagensUltimoID.SQL.Add('SELECT MAX(IDIMAGEM) AS MAXID FROM IMAGENSPRODUTOS');
  TbImagensUltimoID.Open();

  TbImagens.Transaction.StartTransaction();
  try
    TbImagens.SQL.Add('INSERT INTO IMAGENSPRODUTOS(IDIMAGEM, CODIGOBARRAS, IMAGEM) Values(');
    TbImagens.SQL.Add(':IDIMAGEM,');
    TbImagens.SQL.Add(':CODIGOBARRAS,');
    TbImagens.SQL.Add(':IMAGEM);');


    TbImagens.ParamByName('IDIMAGEM').AsInteger    := TbImagensUltimoID.FieldByName('MAXID').AsInteger + 1;
    TbImagens.ParamByName('CODIGOBARRAS').AsString := Self.CodigoBarras;
    TbImagens.ParamByName('IMAGEM').AsStream       := Self.Imagem;

    TbImagens.ExecSQL();
    TbImagens.Transaction.Commit();

    Self.FIdImagem := TbImagensUltimoID.FieldByName('MAXID').AsInteger + 1;
  except
    TbImagens.Transaction.Rollback();
  end;

  FreeAndNil(TbImagens);
  FreeAndNil(TbImagensUltimoID);
end;

procedure TImagemProduto.Editar;
var
  TbImagens: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbImagens :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbImagens.Transaction.StartTransaction();
  try
    TbImagens.SQL.Add('UPDATE IMAGENSPRODUTOS SET');
    TbImagens.SQL.Add('CODIGOBARRAS = :CODIGOBARRAS,');
    TbImagens.SQL.Add('IMAGEM = :IMAGEM');
    TbImagens.SQL.Add('WHERE IDIMAGEM = :IDIMAGEM');

    TbImagens.ParamByName('IDIMAGEM').AsInteger    := Self.IdImagem;
    TbImagens.ParamByName('CODIGOBARRAS').AsString := Self.CodigoBarras;
    TbImagens.ParamByName('IMAGEM').AsStream   := Self.Imagem;

    TbImagens.ExecSQL();
    TbImagens.Transaction.Commit();
  except
    TbImagens.Transaction.Rollback();
  end;

  FreeAndNil(TbImagens);
end;

procedure TImagemProduto.Excluir;
var
  TbImagem: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbImagem := Conexao.GerarQuery();
  TbImagem.SQL.Text := 'DELETE FROM ImagensProdutos WHERE IdImagem = ' + IntToStr(Self.IdImagem);
  TbImagem.ExecSQL();
end;

constructor TImagemProduto.Create();
begin
  inherited Create();
  Self.Imagem := TMemoryStream.Create();
end;

end.
