unit uEditContact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, validator,rest.Types,
  FMX.Objects, FMX.Edit, System.ImageList, FMX.ImgList,uComboBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListBox;

type
  TFEditContact = class(TForm)
    lay_Toolbar: TLayout;
    Txt_title: TText;
    rec_name: TRectangle;
    edt_nombre: TEdit;
    lbl_error_name: TLabel;
    Rec_reg_send: TRectangle;
    lbl_reg_send: TText;
    StyleBook1: TStyleBook;
    lay_name: TLayout;
    lbl_name: TLabel;
    Lay_address: TLayout;
    rec_address: TRectangle;
    edt_address: TEdit;
    lbl_address: TLabel;
    lbl_error_address: TLabel;
    Lay_email: TLayout;
    rec_email: TRectangle;
    edt_email: TEdit;
    lbl_email: TLabel;
    lbl_error_email: TLabel;
    lay_country: TLayout;
    rec_country: TRectangle;
    edt_country: TEdit;
    lbl_country: TLabel;
    lbl_error_country: TLabel;
    Lay_city: TLayout;
    Rec_city: TRectangle;
    edt_city: TEdit;
    lbl_city: TLabel;
    lbl_error_city: TLabel;
    Lay_button: TLayout;
    btn_search_city: TSpeedButton;
    ImageList1: TImageList;
    Lay_zip_code: TLayout;
    Rec_zip_code: TRectangle;
    edt_zip_code: TEdit;
    lbl_zip_code: TLabel;
    lbl_error_zip_code: TLabel;
    MemTable: TFDMemTable;
    Lb_city: TListBox;
    btnAdd: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure rec_countryClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_search_cityClick(Sender: TObject);
    procedure edt_cityEnter(Sender: TObject);
    procedure edt_cityTyping(Sender: TObject);
    procedure Lb_cityItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure lbl_reg_sendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);


  private
    { Private declarations }
   FContactID:integer;
   Fmethod:TRestRequestMethod;
   procedure CreateCountryCombo;
   procedure LoadMemTable(aCountry:integer);
   procedure LoadListBox(aFilter: string);
   function ValidateForm:boolean;
   {$IFDEF MSWINDOWS}
   procedure Country_combo_itemClick(Sender: TObject);
   {$ELSE}
   procedure Country_combo_itemClick(Sender: TObject;const Point: TPointF);
  {$ENDIF}
  public
    { Public declarations }
    property Contact_id:integer read FContactID write fContactID;
    property Method:TRESTRequestMethod read fMethod write fMethod;
  end;

var
  FEditContact: TFEditContact;
  cboCountry:TCustomCombo;


const
 URL_List_Cities = '/zip_codes?$expand=country_id&$filter=country_id/Country_Id eq ';
 URL_Put_contact ='/contacts(:ID)';
 URL_Post_contact ='/contacts';

implementation
uses ws_request,Model.countries,Model.cities,Model.singleContact;
{$R *.fmx}

{ TForm1 }
//-----------------------------------------------------------------------------


{$IFDEF MSWINDOWS}
procedure TFEditContact.Country_combo_itemClick(Sender: TObject);
{$ELSE}
procedure TFEditContact.Country_combo_itemClick(Sender: TObject;const Point: TPointF);
{$ENDIF}
begin
 cboCountry.HideMenu;
 edt_country.Text:=cboCountry.DescrItem;
 edt_country.TagString:=cboCountry.CodItem;
 {Clean the city selection for integrity data }
 edt_city.Text:='';
 edt_city.TagString:='';
 edt_zip_code.Text:='';

 {Load the memTable to seach in the editbox}
 LoadMemTable(cboCountry.CodItem.ToInteger);
end;

//-----------------------------------------------------------------------------

procedure TFEditContact.btnAddClick(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

procedure TFEditContact.btn_search_cityClick(Sender: TObject);
begin
 if edt_country.TagString.IsEmpty then
    edt_country.TagString:='-1';

end;
//-----------------------------------------------------------------------------



//------------------------------------------------------------------------------
procedure TFEditContact.CreateCountryCombo;
var
 i:integer;
 vCountries:TCountries;
 vResponse:unicodestring;
begin
  {Search the list of countries on the server and load in the combobox}

  if ws_request.GetJson('/countries','', rmGet,vResponse) then
    begin
     vCountries:=TCountries.Create;
     try
       vCountries.AsJson:=vResponse;
       cboCountry:=TCustomCombo.Create(self);
       cboCountry.TitleMenuText:='Select a Country';
       cboCountry.SubTitleMenuText:='Scroll the list to search for more countries';
       cboCountry.BackgroundColor:=$FFD6E2F8;
       cboCountry.SubTitleFontColor:=$FFFFFFFF;
       cboCountry.OnClick:=Country_combo_itemClick;


      {loop into the array of country}
      for i := 0 to vCountries.Value.Count -1 do
        cboCountry.AddItem(vCountries.Value[i].CountryId.ToString,
                           vCountries.Value[i].CountryName,'-');

     finally
      vCountries.Free;
     end;


  end;
end;


procedure TFEditContact.edt_cityEnter(Sender: TObject);
begin
 LB_city.Parent:=(sender as Tedit);
end;


//--------------------------------------------------------------------------------------------------
procedure TFEditContact.Lb_cityItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
 ((sender as TCustomListBox).Parent  as Tedit).Text:=Item.Text;
  (sender as TCustomListBox).Visible:=false;
  ((sender as TCustomListBox).Parent  as Tedit).TagString:=Item.TagString;
  Lay_zip_code.Visible:=true;
  edt_zip_code.Text:= TText(Item.TagObject).TagString;
   btn_search_city.ImageIndex:=1;
end;
//--------------------------------------------------------------------------------------------------
procedure TFEditContact.LoadListBox(aFilter:string);
var
 It:TListBoxItem;
begin
 LB_city.BeginUpdate;
 LB_city.Clear;

 try
//  Memtable.Filtered:=false;
  MemTable.Filter:='lower(city_name)  like '+chr(39)+'%'+aFilter.ToLower+'%'+chr(39) ;//+'or Nombre like %'+aFilter+'% or Apellido like %'+aFilter+'%' ;

  Memtable.Filtered:=true;
  MemTable.First;
  while Not MemTable.Eof do
   begin
     It:=TListBoxItem.Create(lb_city);
     It.Parent:=lb_city;
     It.Text:= MemTable.FieldByName('city_name').AsString;
     It.TagString:=MemTable.FieldByName('id').AsString.Trim;
     It.TagObject:=TText.Create(nil);
     TText(It.TagObject).TagString:=MemTable.FieldByName('zip_code').AsString;
     lb_city.AddObject(it);
     MemTable.Next;
   end;

 finally
  lb_city.EndUpdate;
  lb_city.Visible:= lb_city.Items.Count > 0;
  if  lb_city.Items.Count > 0 then
      Lay_zip_code.Visible:=false
  else
     Lay_zip_code.Visible:=true;

 end;
end;
//--------------------------------------------------------------------------------------------------
procedure TFEditContact.edt_cityTyping(Sender: TObject);
var
 vCity:string;
begin
 vCity:=(sender as TEdit).Text;
 btn_search_city.ImageIndex:=0;
 edt_city.TagString:='0';
 LoadListBox(vCity);
end;

//---------------------------------------------------------------------------------------
procedure TFEditContact.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=TCloseAction.caFree;
end;

//---------------------------------------------------------------------------------------
procedure TFEditContact.FormCreate(Sender: TObject);
begin
 {Load the list of countries}
 CreateCountryCombo;
end;
//---------------------------------------------------------------------------------------
procedure TFEditContact.FormDestroy(Sender: TObject);
begin
if assigned(cboCountry) then
  cboCountry.Free;
end;
//----------------------------------------------------------------------------------------------
procedure TFEditContact.FormShow(Sender: TObject);
begin
 LoadMemTable(edt_country.TagString.ToInteger);
end;
//----------------------------------------------------------------------------------------------
procedure TFEditContact.lbl_reg_sendClick(Sender: TObject);
var
 vContact:TSingleContact;
 vURL:string;
 vResponse:string;
begin
 if Not ValidateForm then
  exit;
 vContact:=TSingleContact.Create;
 try
   vContact.ContactId:=FContactID;
   vContact.Name   :=edt_nombre.Text;
   vContact.Email  :=edt_email.Text;
   vContact.Address:=edt_address.Text;
   vContact.ZipId.CountryId.CountryId:=edt_country.TagString.ToInteger;
   vContact.ZipId.CountryId.CountryName:=edt_country.Text;
   vContact.ZipId.ZipId:=edt_city.TagString.ToInteger;
   vContact.ZipId.ZipCityName:=edt_city.Text;
   vContact.ZipId.ZipCode:=edt_zip_code.Text;
   {if is a update}
   if fmethod  = rmPUT then
     vURL:=StringReplace(URL_Put_contact,':ID',FContactID.ToString,[rfReplaceAll,rfIgnoreCase])
   else
     vURL:=URL_Post_contact;

   if ws_request.GetJson(vUrl,vContact.AsJson, fMethod,vResponse) then
    ModalResult:=mrOK
   else
      ShowMessage(vResponse);



 finally
   vContact.Free;
 end;

end;

//---------------------------------------------------------------------------------------
procedure TFEditContact.LoadMemTable(aCountry:integer);
var
 i:integer;
 vCity:TCities;
 vresponse:unicodestring;

begin
 {Load all cities from a country}

 if ws_request.GetJson(URL_List_Cities + aCountry.ToString,'',rmGet,vResponse) then
 begin
  vCity:=TCities.Create;
  try
   //set up the city combo configuration
   vCity.AsJson:=vResponse;

   {loop into the array of country}
   MemTable.ClearDetails;
   MemTable.Active:=true;

   for i := 0 to vCity.Value.Count -1 do
    begin
      MemTable.Insert;
      MemTable.FieldByName('id').AsInteger        :=vCity.Value[i].ZipId;
      MemTable.FieldByName('city_name').AsString  :=vCity.Value[i].ZipCityName;
      MemTable.FieldByName('zip_code').AsString   :=vCity.Value[i].ZipCode;
     MemTable.Post;

    end;

  finally
    vCity.Free;
  end;
 end;
end;

//---------------------------------------------------------------------------------------
procedure TFEditContact.rec_countryClick(Sender: TObject);
begin
  cboCountry.ShowMenu;
end;
//---------------------------------------------------------------------------------------
function TFEditContact.ValidateForm: boolean;
var
 vOK:integer;
 vMsg:string;
begin
 vOK:=0;
try
 {Función utlizada para validar el email}
 if Not validator.IsValidEmail(edt_email.Text) then
  begin
    vMsg:='invalid email';
    rec_email.Stroke.Color:=TAlphaColor($FFFF0000);
    lbl_error_email.Visible:=true;
    lbl_error_email.Text:=vMsg;
    inc(vOk);
  end
 else
  begin
   lbl_error_email.Visible:=false;
   rec_email.Stroke.Color:=TAlphaColor($FF000000);
  end;

 {Validate name}
 if (edt_nombre.Text.IsEmpty) then
  begin
    vMsg:='name is empty';
    lbl_error_name.Visible:=true;
    lbl_error_name.Text:=vMsg;
    rec_name.Stroke.Color:=TAlphaColor($FFFF0000);
    inc(vOK);
  end
 else
  begin
   rec_name.Stroke.Color:=TAlphaColor($FF000000);
   lbl_error_name.Visible:=false;
  end;

 {validate address}
 if (edt_address.Text.IsEmpty) then
  begin
    vMsg:='Address is empty';
    lbl_error_address.Visible:=true;
    lbl_error_address.Text:=vMsg;
    rec_address.Stroke.Color:=TAlphaColor($FFFF0000);
    inc(vOK);
  end
 else
  begin
   rec_address.Stroke.Color:=TAlphaColor($FF000000);
   lbl_error_address.Visible:=false;
  end;

  {validate country}
 if (edt_country.Text.IsEmpty) then
  begin
    vMsg:='Country is empty';
    lbl_error_country.Visible:=true;
    lbl_error_country.Text:=vMsg;
    rec_country.Stroke.Color:=TAlphaColor($FFFF0000);
    inc(vOK);
  end
 else
  begin
   rec_country.Stroke.Color:=TAlphaColor($FF000000);
   lbl_error_country.Visible:=false;
  end;

 {validate City}
 if (edt_city.Text.IsEmpty) then
  begin
    vMsg:='city is empty';
    lbl_error_city.Visible:=true;
    lbl_error_city.Text:=vMsg;
    rec_city.Stroke.Color:=TAlphaColor($FFFF0000);
    inc(vOK);
  end
 else
  begin
   rec_city.Stroke.Color:=TAlphaColor($FF000000);
   lbl_error_city.Visible:=false;
  end;

   {validate zip code}
 if (edt_zip_code.Text.IsEmpty) then
  begin
    vMsg:='Zip code is empty';
    lbl_error_zip_code.Visible:=true;
    lbl_error_zip_code.Text:=vMsg;
    Rec_zip_code.Stroke.Color:=TAlphaColor($FFFF0000);
    inc(vOK);
  end
 else
  begin
   Rec_zip_code.Stroke.Color:=TAlphaColor($FF000000);
   lbl_error_zip_code.Visible:=false;
  end;

finally
  result:=vOK =0;
end;

end;
end.
