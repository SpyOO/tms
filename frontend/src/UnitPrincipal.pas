unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,Rest.Types,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Ani,uFancyDialog;

type
  TFrmPrincipal = class(TForm)
    lytToolbar: TLayout;
    btnRefresh: TSpeedButton;
    VertScrollBox: TVertScrollBox;
    imgFotoCliente: TImage;
    btnAdd: TSpeedButton;
    Animation: TFloatAnimation;
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure AnimationFinish(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Diag:TFancyDialog;
    procedure RefreshList;
    procedure AddContact(aID: integer;
                                   aName, aCity,aCountry: string;
                                   aPicture: TBitmap);
    function GetIDfromImage(aImg:TImage):integer;
     procedure OnClickDeleteDialog(Sender: TObject);
    {$IFDEF MSWINDOWS}
    procedure OnClickEditar(Sender: TObject);
    {$ELSE}
    procedure OnTapEditar(Sender: TObject; const Point: TPointF);
    {$ENDIF}


    {$IFDEF MSWINDOWS}
    procedure OnClickFrame(Sender: TObject);
    {$ELSE}
    procedure OnTapframe(Sender: TObject; const Point: TPointF);
    {$ENDIF}



    {$IFDEF MSWINDOWS}
    procedure OnClickDelete(Sender: TObject);
    {$ELSE}
    procedure OnTapDelete(Sender: TObject; const Point: TPointF);
    {$ENDIF}

    procedure ClearVertScrollBox(VSBox: TVertScrollBox; Index: integer = -1);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;
const
  URL_Get_contacts = '/contacts/?$expand=zip_id/country_id';
  URL_Get_contact = '/contacts??$expand=zip_id/country_id&$filter=contact_id eq ';
  URL_delete_contact = '/contacts(:ID)';
implementation

{$R *.fmx}

uses Frame.Contact,model.contacts,ws_request,uEditContact;


{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.OnClickEditar(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.OnTapEditar(Sender: TObject; const Point: TPointF);
{$ENDIF}
var
 F:TFEditContact;
 vContact:TContact;
 vResponse:UnicodeString;
 vContactID:integer;
begin
 //Get the id contact from the image clicked
 vContactID:=GetIDfromImage( (Sender as Timage));

 if ws_request.GetJson(URL_Get_contact + vContactID.ToString,'',rmGet,vResponse) then
  begin
     vContact:=TContact.Create;
     vContact.AsJson:=vResponse;
     F:=TFEditContact.Create(self);
     try
      F.Contact_id :=vContactID;
      F.Method     :=rmPut;
      F.edt_nombre.Text  :=vContact.Value[0].Name;
      F.edt_address.Text :=vContact.Value[0].Address;
      F.edt_email.Text   :=vContact.Value[0].Email;
      F.edt_country.Text :=vContact.Value[0].ZipId.CountryId.CountryName;
      F.edt_country.TagString:=vContact.Value[0].ZipId.CountryId.CountryId.ToString;
      F.edt_city.Text    :=vContact.Value[0].ZipId.ZipCityName;
      F.edt_city.TagString:=vContact.Value[0].ZipId.ZipId.tostring;
      F.btn_search_city.ImageIndex:=1;
      F.edt_zip_code.Text:=vContact.Value[0].ZipId.ZipCode;
      F.ShowModal(procedure(AModalResult: TModalResult)
       begin
          if AModalResult = mrOK then
           RefreshList;

       end);
     finally
       vContact.Free;
     end;
  end;
end;

//---------------------------------------------------------------------------------------
{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.OnClickFrame(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.OnTapframe(Sender: TObject; const Point: TPointF);
{$ENDIF}
begin
  {  showmessage('click en el frame del clciente: ' + TFrameContact(Sender).id_contact .ToString +
                        ' - ' + TFrameContact(Sender).name);       }
end;

procedure TFrmPrincipal.OnClickDeleteDialog(Sender: TObject);
var
 rect: TRectangle;
 frame: TFrame;
 imgDelete: TImage;
 vContactID:integer;
 vResponse,vUrl:string;
begin
     //get image from recycle clicked...
    imgDelete := TImage(Diag.TagObject);
    vContactID:=GetIDfromImage(ImgDelete);

    vUrl:=StringReplace(URL_delete_contact,':ID',vContactID.ToString,[rfReplaceAll,rfIgnoreCase]);

    if ws_request.GetJson(vURl,'',rmDELETE,vResponse) then
     begin
      // get recycle rectangle...
      rect := imgDelete.Parent as TRectangle;
      // Cqapture frame...
      frame := rect.Parent as TFrame;

      Animation.Parent := frame;
      Animation.Start;
     end;
end;

//---------------------------------------------------------------------------------------
{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.OnClickDelete(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.OnTapDelete(Sender: TObject; const Point: TPointF);
{$ENDIF}

begin
    Diag.TagObject:=Sender;
    Diag.Show(TIconDialog.Question,'Delete contact','Are you sure?','NO',nil,'Delete',OnClickDeleteDialog);




end;


//---------------------------------------------------------------------------------------------------
procedure TFrmPrincipal.ClearVertScrollBox(VSBox: TVertScrollBox; Index: integer = -1);
var
    i: integer;
begin
    try
        VSBox.BeginUpdate;

        if Index >= 0 then
            TFrame(VSBox.Content.Children[Index]).DisposeOf
        else
        for i := VSBox.Content.ChildrenCount - 1 downto 0 do
            if VSBox.Content.Children[i] is TFrame then
                TFrame(VSBox.Content.Children[i]).DisposeOf;

    finally
        VSBox.EndUpdate;
    end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
 {Create the fancy Dialog manager }
 Diag:=TFancyDialog.Create(self);
 RefreshList;
end;
//-----------------------------------------------------------------------------------------------
procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
 Diag.Free;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin

end;

//-----------------------------------------------------------------------------------------------
function TFrmPrincipal.GetIDfromImage(aImg: TImage): integer;
var
 vRect:TRectangle;
 vFrame:TFrame;

begin

    // get img rectangle...
    vRect := aImg.Parent as TRectangle;
    // Capture frame...
    vframe := vRect.Parent as TFrame;
    result:=(vFrame as TFrameContact).id_contact;
end;

//---------------------------------------------------------------------------------------
procedure TFrmPrincipal.AddContact(aID: integer;
                                   aName, ACity,ACountry: string;
                                   aPicture: TBitmap);
var
    frame: TFrameContact;
begin
    frame := TFrameContact.create(nil);

    frame.id_contact := AID;
    frame.name := AName;
    frame.position.Y := 9999999999;
    frame.align := TAlignLayout.Top;
   // frame.imgFoto.bitmap := aPicture;
    frame.lblName.text := aName;
    frame.lblCity.text := aCity + ' - ' + ACountry;
    frame.imgEdit.Tag := aID;

    {$IFDEF MSWINDOWS}
    frame.onClick := OnClickFrame;
    {$ELSE}
    frame.onTap := OnTapFrame;
    {$ENDIF}


    {$IFDEF MSWINDOWS}
    frame.imgDelete.onClick := OnClickDelete;
    {$ELSE}
    frame.imgDelete.onTap := OnTapDelete;
    {$ENDIF}


    {$IFDEF MSWINDOWS}
    frame.imgEdit.onClick := OnClickEditar;
    {$ELSE}
    frame.imgEdit.onTap := OnTapEditar;
    {$ENDIF}



    VertScrollBox.AddObject(frame);


end;
//---------------------------------------------------------------------------------------
procedure TFrmPrincipal.AnimationFinish(Sender: TObject);
var
    frame: TFrame;
begin
    frame := TFloatAnimation(Sender).Parent as Tframe;

    Animation.Parent := nil;
    ClearVertScrollBox(VertScrollBox, frame.Index);
end;
//---------------------------------------------------------------------------------------
procedure TFrmPrincipal.btnAddClick(Sender: TObject);
var
 F:TFEditContact;

begin
 //Get the id contact from the image clicked
  F:=TFEditContact.Create(self);
     try
      F.Contact_id :=0;
      F.Method     :=rmPost;
      F.edt_country.TagString:='0';
      F.edt_city.TagString:='0';
      F.btn_search_city.ImageIndex:=0;
      F.ShowModal(procedure(AModalResult: TModalResult)
       begin
          if AModalResult = mrOK then
           RefreshList;

       end);
     finally
     end;
end;
//---------------------------------------------------------------------------------------
procedure TFrmPrincipal.RefreshList;
var
 i: integer;
 vContact:TContact;
 vResponse:UnicodeString;
begin
    ClearVertScrollBox(VertScrollBox);
    VertScrollBox.BeginUpdate;
    vContact:=TContact.Create;
    try
     if ws_request.GetJson(URL_Get_contacts,'',rmGet,vResponse) then
      begin
       vContact.AsJson:=vresponse;
       for i := 0 to vContact.Value.Count -1 do
          AddContact(vContact.Value[i].ContactId,vContact.Value[i].Name,
                     vContact.Value[i].ZipId.ZipCityName,
                     vContact.Value[i].ZipId.CountryId.CountryName,nil);
      end;

    finally
      vContact.Free;
      VertScrollBox.EndUpdate;
    end;
end;
//---------------------------------------------------------------------------------------

procedure TFrmPrincipal.btnRefreshClick(Sender: TObject);
begin
 RefreshList;
end;

end.
