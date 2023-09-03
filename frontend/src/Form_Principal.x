unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, Data.DB, FMX.TextLayout, FMX.Ani, FMX.Layouts;

type
  TFrm_Principal = class(TForm)
    ToolBar1: TToolBar;
    ListView: TListView;
    btn_refresh: TSpeedButton;
    img_done: TImage;
    img_detalhe: TImage;
    rect_loading: TRectangle;
    Arc1: TArc;
    FloatAnimation1: TFloatAnimation;
    img_mais: TImage;
    FloatAnimation2: TFloatAnimation;
    Layout1: TLayout;
    procedure btn_refreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewUpdateObjects(const Sender: TObject; const AItem: TListViewItem);
    procedure ListViewItemClickEx(const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure ListViewItemClick(const Sender: TObject;   const AItem: TListViewItem);
    procedure ListViewDeletingItem(Sender: TObject; AIndex: Integer;  var ACanDelete: Boolean);
    procedure ListViewPullRefresh(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure img_maisClick(Sender: TObject);
  private
    { Private declarations }
    num_pagina : integer;
    procedure AddContactToList(AName, AEMail, ACountryName:string; AID: integer);
  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;
const
  URL_Get_contacts = '/list_contacts';
implementation

{$R *.fmx}

uses Data_Module,ws_request,Model.contacts,Pkg.Json.DTO;

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrm_Principal.AddContactToList(AName, AEMail, ACountryName:string; AID: integer);
var
  vItem : TListViewItem;
  vTxt : TListItemText;
begin
  vItem := ListView.Items.Add;
  with vItem do
   begin
      vTxt := TListItemText(Objects.FindDrawable('txt_name'));
      vTxt.Text := AName;

   end;
end;

procedure Add_Tarefa(cod_tarefa : integer; descricao, categoria, status,
                     data_tarefa, hora : string; icone : TStream);
var
        Item : TListViewItem;
        img : TListItemImage;
        bmp : TBitmap;
        txt : TListItemText;
        btn : TListItemTextButton;
begin
        with Frm_Principal do
        begin
                item.TagString := cod_tarefa.ToString;

                with item do
                begin
                        // Icone...
                        if icone <> nil then
                        begin
                                bmp := TBitmap.Create;
                                bmp.LoadFromStream(icone);
                        end;

                        img := TListItemImage(Objects.FindDrawable('Image3'));
                        img.OwnsBitmap := true;
                        img.Bitmap := bmp;


                        // Descricao...
                        txt := TListItemText(Objects.FindDrawable('txt_name'));
                        txt.Text := descricao;


                        // Data e Hora...
                        txt := TListItemText(Objects.FindDrawable('Text2'));
                        txt.Text := data_tarefa + ' - ' + hora;


                        // Tarefa concluida...
                        bmp := TBitmap.Create;
                        bmp.Assign(img_done.Bitmap);

                        img := TListItemImage(Objects.FindDrawable('Image4'));
                        img.OwnsBitmap := true;
                        img.Bitmap := bmp;

                        if status = 'F' then
                                img.Visible := true
                        else
                                img.Visible := false;

                        // Icone detalhes...
                        bmp := TBitmap.Create;
                        bmp.Assign(img_detalhe.Bitmap);

                        img := TListItemImage(Objects.FindDrawable('Image5'));
                        img.OwnsBitmap := true;
                        img.Bitmap := bmp;
                        img.TagString := status;


                        // Botao concluido...
                        btn := TListItemTextButton(Objects.FindDrawable('TextButton7'));
                        btn.TagString := cod_tarefa.ToString;
                        if status = 'F' then
                                btn.Text := 'Não Concluído'
                        else
                                btn.Text := 'Marcar Concluído';

                end;
        end;
end;

procedure Carrega_Tarefas();
begin
        if Frm_Principal.ListView.Items.Count > 30 then
            exit;

        if Frm_Principal.ListView.Tag > 0 then
            exit;

        Frm_Principal.ListView.Tag := 1; // Em processamento...

        TThread.CreateAnonymousThread(
        procedure
        var
            x, cod_tarefa : integer;
            icone : TStream;
        begin
                // Busca icone...
                dm.qry_geral.Active := false;
                dm.qry_geral.sql.Clear;
                dm.qry_geral.sql.Add('SELECT * FROM TAB_TAREFA WHERE CATEGORIA = ''GERAL'' ');
                dm.qry_geral.Active := true;

                icone := dm.qry_geral.CreateBlobStream(dm.qry_geral.FieldByName('ICONE'), TBlobStreamMode.bmRead);

                with Frm_Principal do
                begin
                        num_pagina := num_pagina + 1;

                        for x := 1 to 20 do
                        begin
                                cod_tarefa := x * num_pagina;

                                TThread.Synchronize(nil, procedure
                                begin
                                        Add_Tarefa(cod_tarefa,
                                               'Tarefa ' + cod_tarefa.ToString,
                                               'GERAL',
                                               'A',
                                               '15/08/2019',
                                               '08:00',
                                               icone);
                                end);

                        end;
                end;

                Frm_Principal.ListView.Tag := 0;  // Processamento terminou...

        end).Start;
end;



procedure TFrm_Principal.btn_refreshClick(Sender: TObject);
var
  icone : TStream;
  vResponse:unicodestring;
  vContact:TContacts;
  i:integer;
begin

  ListView.Items.Clear;
  ListView.BeginUpdate;
  if ws_request.GetJson(URL_Get_contacts,'',vResponse) then
   begin
    vContact:=TContacts.Create;
    try
     vContact.AsJson:=vResponse;
     for i := 0 to vContact.Value.Count - 1 do
     begin
       AddContactToList(vContact.Value[i].Name,
                        vContact.Value[i].Email,
                        vContact.Value[i].CountryName,
                        vContact.Value[i].Id);
     end;
    finally
      vContact.Free;
    end;

      {if 1<>1 then
        icone:=nil
      else
        icone := nil; }

      {Add_Tarefa(qry_geral.FieldByName('COD_TAREFA').AsInteger,
                                     qry_geral.FieldByName('DESCRICAO').AsString,
                                     qry_geral.FieldByName('CATEGORIA').AsString,
                                     qry_geral.FieldByName('STATUS').AsString,
                                     FormatDateTime('dd/mm/yyyy', qry_geral.FieldByName('DATA').AsDateTime),
                                     qry_geral.FieldByName('HORA').AsString,
                                     icone); }

    end;

    ListView.EndUpdate;

end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
        img_done.Visible := false;
        img_detalhe.Visible := false;
        ListView.DeleteButtonText := 'Delete';
        num_pagina := 0;
end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
        rect_loading.Visible := false;

        img_mais.Margins.Bottom := -100;
        FloatAnimation2.StartValue := -100;
        FloatAnimation2.StopValue := 15;
end;

procedure TFrm_Principal.img_maisClick(Sender: TObject);
var
        altura_item : integer;
begin
        altura_item := 150;
        ListView.AnimateFloat('ScrollViewPos', ListView.ItemCount * altura_item, 0.6);
end;

procedure TFrm_Principal.ListViewDeletingItem(Sender: TObject; AIndex: Integer;
  var ACanDelete: Boolean);
var
        btn : TListItemTextButton;
        cod_tarefa : string;
begin
        btn := TListItemTextButton(TListView(sender).items[AIndex].Objects.FindDrawable('TextButton7'));
        cod_tarefa := TListView(sender).items[AIndex].TagString;


        // Excluir somente se tareda nao concluida...
        if btn.Text = 'Marcar Concluído' then
        begin
                dm.qry_geral.Active := false;
                dm.qry_geral.sql.Clear;
                dm.qry_geral.sql.Add('DELETE FROM TAB_TAREFA');
                dm.qry_geral.sql.Add('WHERE COD_TAREFA=:COD_TAREFA');
                dm.qry_geral.ParamByName('COD_TAREFA').Value := cod_tarefa;
                dm.qry_geral.ExecSQL;
        end
        else
        begin
                ACanDelete := false;
                showmessage('Somente tarefas não concluídas podem ser excluídas');
        end;

end;

procedure TFrm_Principal.ListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
        // Recuperar o cod. tarefa selecionado...
        //showmessage('Item clicado: ' + Aitem.TagString);
end;

procedure TFrm_Principal.ListViewItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
        status, cod_tarefa : string;
        img : TListItemImage;
        indice : integer;
begin
        // Recuperar o cod. tarefa selecionado...
        //showmessage('Item clicado ex: ' + ListView.Items[ItemIndex].TagString);

        if TListView(sender).Selected <> nil then
        begin
                indice := TListView(sender).Selected.Index;

                if ItemObject is TListItemTextButton then
                begin
                        if TListItemTextButton(ItemObject).Name = 'TextButton7' then
                        begin
                                // Marcar tarefa nao concluida...
                                if TListItemTextButton(ItemObject).Text = 'Não Concluído' then
                                        status := 'A'
                                else
                                        status := 'F';

                                // Atualiza banco de dados...
                                try
                                        cod_tarefa := TListItemTextButton(ItemObject).TagString;

                                        dm.qry_geral.Active := false;
                                        dm.qry_geral.sql.Clear;
                                        dm.qry_geral.sql.Add('UPDATE TAB_TAREFA SET STATUS=:STATUS');
                                        dm.qry_geral.sql.Add('WHERE COD_TAREFA=:COD_TAREFA');
                                        dm.qry_geral.ParamByName('STATUS').Value := status;
                                        dm.qry_geral.ParamByName('COD_TAREFA').Value := cod_tarefa;
                                        dm.qry_geral.ExecSQL;

                                        img := TListItemImage(ListView.Items[indice].Objects.FindDrawable('Image4'));
                                        if status = 'F' then
                                        begin
                                                img.Visible := true;
                                                TListItemTextButton(ItemObject).Text := 'Não Concluído';
                                        end
                                        else
                                        begin
                                                img.Visible := false;
                                                TListItemTextButton(ItemObject).Text := 'Marcar Concluído'
                                        end;
                                except

                                end;

                        end;
                end;
        end;
end;

procedure TFrm_Principal.ListViewPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
        if ListView.Items.Count > 0 then
        begin
                if ListView.GetItemRect(ListView.Items.Count - 5).Bottom <= ListView.Height then
                    Carrega_Tarefas();


                if NOT FloatAnimation2.Running then
                begin
                        // Exibir seta de mais conteudo...
                        if ListView.GetItemRect(ListView.Items.Count - 1).Bottom > ListView.Height + 20 then
                        begin
                                if img_mais.Tag = 0 then
                                begin
                                        FloatAnimation2.Inverse := false;
                                        FloatAnimation2.Start;
                                        img_mais.Tag := 1;
                                end;
                        end
                        else
                        begin
                                if img_mais.Tag = 1 then
                                begin
                                        FloatAnimation2.Inverse := true;
                                        FloatAnimation2.Start;
                                        img_mais.Tag := 0;
                                end;
                        end;
                end;
        end;
end;

procedure TFrm_Principal.ListViewPullRefresh(Sender: TObject);
var
        icone : TStream;
begin
        num_pagina := num_pagina + 1;
        rect_loading.Visible := true;
        FloatAnimation1.Start;

        // Carga dos dados...
        TThread.CreateAnonymousThread(
        procedure
        begin
                with dm do
                begin
                        qry_geral.Active := false;
                        qry_geral.sql.Clear;
                        qry_geral.sql.Add('SELECT * FROM TAB_TAREFA');
                        qry_geral.sql.Add('WHERE PAGINA = :PAGINA');
                        qry_geral.ParamByName('PAGINA').Value := num_pagina;
                        qry_geral.Active := true;

                        ListView.BeginUpdate;

                        while NOT qry_geral.Eof do
                        begin
                                Sleep(3000);

                                if qry_geral.FieldByName('ICONE').AsString <> '' then
                                        icone := qry_geral.CreateBlobStream(qry_geral.FieldByName('ICONE'), TBlobStreamMode.bmRead)
                                else
                                        icone := nil;

                                TThread.Synchronize(nil,
                                procedure
                                begin
                                        Add_Tarefa(qry_geral.FieldByName('COD_TAREFA').AsInteger,
                                                   qry_geral.FieldByName('DESCRICAO').AsString,
                                                   qry_geral.FieldByName('CATEGORIA').AsString,
                                                   qry_geral.FieldByName('STATUS').AsString,
                                                   FormatDateTime('dd/mm/yyyy', qry_geral.FieldByName('DATA').AsDateTime),
                                                   qry_geral.FieldByName('HORA').AsString,
                                                   icone);
                                end
                                );

                                qry_geral.next;
                        end;

                        ListView.EndUpdate;

                        //ListView.StopPullRefresh;
                        FloatAnimation1.Stop;
                        rect_loading.Visible := false;
                end;

        end).Start;

end;

procedure TFrm_Principal.ListViewUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
        txt : TListItemText;
        img : TListItemImage;
        btn : TListItemTextButton;
        aux : single;
        status : string;
begin
        with AItem do
        begin
                // Descricao...
                txt := TListItemText(Objects.FindDrawable('Text1'));
                txt.PlaceOffset.Y :=  11;
                txt.WordWrap := true;
                txt.Width := Frm_Principal.Width - txt.PlaceOffset.X - 70;
                txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 3;
                aux := txt.Height;


                // Data e Hora...
                txt := TListItemText(Objects.FindDrawable('Text2'));
                txt.PlaceOffset.Y := 9 + aux;


                // Altura do item...
                Height := trunc(aux + txt.Height + 22) + 50;


                // Icone...
                img := TListItemImage(Objects.FindDrawable('Image3'));
                img.Height := 42;
                img.OwnsBitmap := true;
                img.PlaceOffset.Y := trunc(Height / 2) - 21;
                img.Opacity := 0.8;
                aux := img.PlaceOffset.Y;


                // Icone detalhes...
                img := TListItemImage(Objects.FindDrawable('Image5'));
                img.OwnsBitmap := true;
                img.PlaceOffset.Y := aux;
                img.Opacity := 0.4;
                img.Height := 14;
                img.Width := 14;

                status := img.TagString;


                // Tarefa concluida...
                img := TListItemImage(Objects.FindDrawable('Image4'));
                img.OwnsBitmap := true;
                img.PlaceOffset.Y := aux;
                img.Opacity := 0.6;
                img.Height := 14;
                img.Width := 14;

                if status = 'F' then
                        img.Visible := true
                else
                        img.Visible := false;


                // Criar texto importante...
                {
                txt := TListItemText.Create(Aitem);
                txt.Text := 'Importante';
                txt.Name := 'TextImportante';
                txt.Font.Size := 8;
                txt.TextColor := $FF7E7E7E;
                txt.Width := 50;
                txt.PlaceOffset.x := Frm_Principal.Width - 80;
                txt.PlaceOffset.Y := Height - 25;
                }


                // Botao concluido...
                btn := TListItemTextButton(Objects.FindDrawable('TextButton7'));
                btn.Height := 30;
                btn.Width := 140;
                btn.PlaceOffset.X := 51;
                btn.PlaceOffset.Y := Height - 50;

                if status = 'F' then
                    btn.Text := 'Não Concluído'
                else
                    btn.Text := 'Marcar Concluído';
        end;
end;

end.
