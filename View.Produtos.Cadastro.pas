unit View.Produtos.Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Model.Produto, Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ExtDlgs,
  pngimage,
  jpeg;

type
  TFrmProdutosCadastro = class(TForm)
    EdtCodBarras: TLabeledEdit;
    EdtDescricao: TLabeledEdit;
    LblEstoque: TLabel;
    SedEstoque: TSpinEdit;
    EdtPrecoVenda: TLabeledEdit;
    BtnSalvar: TButton;
    BtnCancelar: TButton;
    BtnIncluirImagem: TButton;
    BtnAlterarImagem: TButton;
    BtnExcluirImagem: TButton;
    ImgFotoProduto: TImage;
    DlgImagem: TOpenDialog;
    BtnProximaImg: TButton;
    BtnImgAnterior: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure EdtPrecoVendaExit(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnIncluirImagemClick(Sender: TObject);
    procedure BtnAlterarImagemClick(Sender: TObject);
    procedure BtnExcluirImagemClick(Sender: TObject);
    procedure BtnProximaImgClick(Sender: TObject);
    procedure BtnImgAnteriorClick(Sender: TObject);
  private
    { Private declarations }
    IndiceAtualImg: Integer;
    Produto: TProduto;
  public
    { Public declarations }

    constructor Create(AOwner: TComponent; AProduto: TProduto); overload;
  end;

var
  FrmProdutosCadastro: TFrmProdutosCadastro;

implementation

{$R *.dfm}

procedure TFrmProdutosCadastro.BtnAlterarImagemClick(Sender: TObject);
begin
  if Self.DlgImagem.Execute() then
  begin
    if FileExists(Self.DlgImagem.FileName) then
    begin
      var Imagem: TImagemProduto;
      Imagem := TImagemProduto.Create();
      Imagem.Imagem.LoadFromFile(Self.DlgImagem.FileName);

      Self.ImgFotoProduto.Picture.LoadFromStream(Imagem.Imagem);
      Self.Produto.ListaImagens[IndiceAtualImg].Imagem := Imagem.Imagem;
    end;
  end;
end;

procedure TFrmProdutosCadastro.BtnCancelarClick(Sender: TObject);
begin
  Self.Close();
end;

procedure TFrmProdutosCadastro.BtnExcluirImagemClick(Sender: TObject);
begin
  Self.Produto.ListaImagens[IndiceAtualImg].Excluir();
end;

procedure TFrmProdutosCadastro.BtnImgAnteriorClick(Sender: TObject);
begin
  Dec(Self.IndiceAtualImg);
  Self.Produto.ListaImagens[Self.IndiceAtualImg].Imagem.Position := 0;
  Self.ImgFotoProduto.Picture.LoadFromStream(Self.Produto.ListaImagens[Self.IndiceAtualImg].Imagem);
  Self.ImgFotoProduto.Repaint();
  Self.Refresh();

  Self.BtnImgAnterior.Enabled := Self.IndiceAtualImg > 0;
  Self.BtnProximaImg.Enabled  := Self.Produto.ListaImagens.Count > Self.IndiceAtualImg + 1;
end;

procedure TFrmProdutosCadastro.BtnIncluirImagemClick(Sender: TObject);
begin
  if Self.DlgImagem.Execute() then
  begin
    if FileExists(Self.DlgImagem.FileName) then
    begin
      var Imagem: TImagemProduto;
      Imagem := TImagemProduto.Create();
      Imagem.Imagem.LoadFromFile(Self.DlgImagem.FileName);

      Self.ImgFotoProduto.Picture.LoadFromStream(Imagem.Imagem);
      Self.Produto.ListaImagens.Add(Imagem);
    end;
  end;
end;

procedure TFrmProdutosCadastro.BtnProximaImgClick(Sender: TObject);
begin
  Inc(Self.IndiceAtualImg);
  Self.Produto.ListaImagens[Self.IndiceAtualImg].Imagem.Position := 0;
  Self.ImgFotoProduto.Picture.LoadFromStream(Self.Produto.ListaImagens[Self.IndiceAtualImg].Imagem);
  Self.ImgFotoProduto.Repaint();
  Self.Refresh();

  Self.BtnImgAnterior.Enabled := Self.IndiceAtualImg > 0;
  Self.BtnProximaImg.Enabled  := Self.Produto.ListaImagens.Count > Self.IndiceAtualImg + 1;
end;

procedure TFrmProdutosCadastro.BtnSalvarClick(Sender: TObject);
begin
  Self.Produto.CodigoBarras := Self.EdtCodBarras.Text;
  Self.Produto.Descricao    := Self.EdtDescricao.Text;
  Self.Produto.PrecoVenda   := StrToFloat(Self.EdtPrecoVenda.Text);
  Self.Produto.Estoque      := Self.SedEstoque.Value;

  Self.Produto.Gravar();
  Self.Close();
end;

constructor TFrmProdutosCadastro.Create(AOwner: TComponent; AProduto: TProduto);
begin
  inherited Create(AOwner);

  Self.Produto := AProduto;
end;

procedure TFrmProdutosCadastro.EdtPrecoVendaExit(Sender: TObject);
begin
  Self.EdtPrecoVenda.Text := FormatFloat('###0.00', StrToFloat(Self.EdtPrecoVenda.Text));
end;

procedure TFrmProdutosCadastro.FormCreate(Sender: TObject);
begin
  if not Assigned(Produto) then
  begin
    Produto := TProduto.Create();
  end;

  Self.IndiceAtualImg := 0;

  if Produto.CodigoBarras <> '' then
  begin
    Self.Caption := 'Editando produto';
    Self.EdtCodBarras.Enabled := False;

    Self.EdtCodBarras.Text  := Self.Produto.CodigoBarras;
    Self.EdtDescricao.Text  := Self.Produto.Descricao;
    Self.EdtPrecoVenda.Text := FormatFloat('###0.00', Self.Produto.PrecoVenda);
    Self.SedEstoque.Value := Self.Produto.Estoque;

    if Self.Produto.ListaImagens.Count > 0 then
    begin
      Self.ImgFotoProduto.Picture.LoadFromStream(Self.Produto.ListaImagens[Self.IndiceAtualImg].Imagem);
      Self.BtnImgAnterior.Enabled := Self.IndiceAtualImg > 0;
      Self.BtnProximaImg.Enabled  := Self.Produto.ListaImagens.Count > Self.IndiceAtualImg + 1;
    end;
  end
  else
  begin
    Self.Caption := 'Incluindo novo produto';
  end;
end;

end.
