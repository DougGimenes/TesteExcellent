program TesteExcellent;

uses
  Vcl.Forms,
  View.Produtos.Geral in 'View.Produtos.Geral.pas' {FrmProdutos},
  Model.Produto in 'Model\Model.Produto.pas',
  Controller.Connection in 'Connection\Controller.Connection.pas',
  View.Produtos.Cadastro in 'View.Produtos.Cadastro.pas' {FrmProdutosCadastro},
  Model.Pedido in 'Model\Model.Pedido.pas',
  View.Pedidos.Geral in 'View.Pedidos.Geral.pas' {FrmPedidosGeral},
  View.Pedidos.Cadastro in 'View.Pedidos.Cadastro.pas' {FrmNovoPedido},
  View.Main in 'View.Main.pas' {FrmMain};

{$R *.res}
var
  Conexao: TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  Conexao.GerarConexao('C:\TesteExcellent\DataBase\BANCODADOS.FDB', 'sysdba', 'masterkey', 'C:\TesteExcellent\DataBase\conexao.ini');

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
