unit View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  View.Pedidos.Geral,
  View.Produtos.Geral;

type
  TFrmMain = class(TForm)
    BtnProdutos: TButton;
    BtnPedidos: TButton;
    procedure BtnProdutosClick(Sender: TObject);
    procedure BtnPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.BtnPedidosClick(Sender: TObject);
var
  FrmPedidos: TFrmPedidosGeral;
begin
  FrmPedidos := TFrmPedidosGeral.Create(Self);
  try
    FrmPedidos.ShowModal();
  finally
    FreeAndNil(FrmPedidos);
  end;
end;

procedure TFrmMain.BtnProdutosClick(Sender: TObject);
var
  FrmProdutos: TFrmProdutos;
begin
  FrmProdutos := TFrmProdutos.Create(Self);
  try
    FrmProdutos.ShowModal();
  finally
    FreeAndNil(FrmProdutos);
  end;
end;

end.
