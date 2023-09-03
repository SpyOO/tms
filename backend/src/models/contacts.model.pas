unit contacts.model;

interface

uses
  SysUtils, 
  Generics.Collections, 
  Aurelius.Mapping.Attributes, 
  Aurelius.Types.Blob, 
  Aurelius.Types.DynamicProperties, 
  Aurelius.Types.Nullable, 
  Aurelius.Types.Proxy, 
  Aurelius.Dictionary.Classes, 
  Aurelius.Linq;

type
  Tcontacts = class;
  Tcountries = class;
  Tzip_codes = class;
  TList_contacts = class;

  TcontactsDictionary = class;
  TcountriesDictionary = class;
  Tzip_codesDictionary = class;
  TListContactsDictionary =class;

  [Entity]
  [Table('contacts')]
  [Id('FContact_Id', TIdGenerator.IdentityOrSequence)]
  Tcontacts = class
  private
    [Column('contact_id', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FContact_Id: Integer;

    [Column('name', [TColumnProp.Required], 60)]
    FName: string;

    [Column('address', [TColumnProp.Required], 100)]
    FAddress: string;

    [Column('email', [TColumnProp.Required], 256)]
    FEmail: string;

    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('zip_id', [TColumnProp.Required], 'zip_id')]
    Fzip_id: Proxy<Tzip_codes>;
    function Getzip_id: Tzip_codes;
    procedure Setzip_id(const Value: Tzip_codes);
  public
    property Contact_Id: Integer read FContact_Id write FContact_Id;
    property Name: string read FName write FName;
    property Address: string read FAddress write FAddress;
    property Email: string read FEmail write FEmail;
    property zip_id: Tzip_codes read Getzip_id write Setzip_id;
  end;

  [Entity]
  [Table('countries')]
  [Id('FCountry_Id', TIdGenerator.IdentityOrSequence)]
  Tcountries = class
  private
    [Column('country_id', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FCountry_Id: Integer;

    [Column('country_name', [], 100)]
    FCountry_Name: Nullable<string>;
  public
    property Country_Id: Integer read FCountry_Id write FCountry_Id;
    property Country_Name: Nullable<string> read FCountry_Name write FCountry_Name;
  end;


  [Entity]
  [Table('List_contacts')]
  [Id('FContact_Id', TIdGenerator.IdentityOrSequence)]
  TList_contacts = class
  private
    [Column('contact_id', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FContact_Id: Integer;

    [Column('name', [], 100)]
    FName: Nullable<string>;

    [Column('address', [], 100)]
    FAddress: Nullable<string>;

    [Column('email', [], 100)]
    FEmail: Nullable<string>;

    [Column('zip_id', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FZip_id: Integer;

    [Column('zip_city_name', [], 100)]
    Fzip_city_name: Nullable<string>;

    [Column('zip_code', [], 100)]
    FZip_code: Nullable<string>;


    [Column('country_id', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FCountry_Id: Integer;

    [Column('country_name', [], 100)]
    FCountry_Name: Nullable<string>;
  public
    property Contact_id: integer read FContact_id write FContact_Id;
    property Name: Nullable<string> read FName write fName;
    property Address: Nullable<string> read FAddress write fAddress;
    property Email: Nullable<string> read FEmail write fEmail;
    property zip_id: integer read Fzip_id write Fzip_Id;
    property zip_city_name: Nullable<string> read Fzip_city_name write Fzip_city_name;
    property zip_code: Nullable<string> read Fzip_code write Fzip_code;
    property Country_Id: Integer read FCountry_Id write FCountry_Id;
    property Country_Name: Nullable<string> read FCountry_Name write FCountry_Name;
  end;


  [Entity]
  [Table('zip_codes')]
  [Id('FZip_Id', TIdGenerator.IdentityOrSequence)]
  Tzip_codes = class
  private
    [Column('zip_id', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FZip_Id: Integer;

    [Column('zip_city_name', [TColumnProp.Required], 60)]
    FZip_City_Name: string;

    [Column('zip_code', [TColumnProp.Required], 10)]
    FZip_Code: string;

    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('country_id', [TColumnProp.Required], 'country_id')]
    Fcountry_id: Proxy<Tcountries>;
    function Getcountry_id: Tcountries;
    procedure Setcountry_id(const Value: Tcountries);
  public
    property Zip_Id: Integer read FZip_Id write FZip_Id;
    property Zip_City_Name: string read FZip_City_Name write FZip_City_Name;
    property Zip_Code: string read FZip_Code write FZip_Code;
    property country_id: Tcountries read Getcountry_id write Setcountry_id;
  end;

  IcontactsDictionary = interface;

  IcountriesDictionary = interface;

  Izip_codesDictionary = interface;

  IList_contactsDictionary = interface;

  IcontactsDictionary = interface(IAureliusEntityDictionary)
    function Contact_Id: TLinqProjection;
    function Name: TLinqProjection;
    function Address: TLinqProjection;
    function Email: TLinqProjection;
    function zip_id: Izip_codesDictionary;
  end;

  IcountriesDictionary = interface(IAureliusEntityDictionary)
    function Country_Id: TLinqProjection;
    function Country_Name: TLinqProjection;
  end;

  Izip_codesDictionary = interface(IAureliusEntityDictionary)
    function Zip_Id: TLinqProjection;
    function Zip_City_Name: TLinqProjection;
    function Zip_Code: TLinqProjection;
    function country_id: IcountriesDictionary;
  end;

  IList_contactsDictionary =interface(IAureliusEntityDictionary)
    function Contact_id: TLinqProjection;
    function Name: TLinqProjection;
    function Address: TLinqProjection;
    function Email: TLinqProjection;
    function zip_id: TLinqProjection;
    function zip_city_name: TLinqProjection;
    function zip_code: TLinqProjection;
    function Country_Id: TLinqProjection;
    function Country_Name: TLinqProjection;
  end;

  TcontactsDictionary = class(TAureliusEntityDictionary, IcontactsDictionary)
  public
    function Contact_Id: TLinqProjection;
    function Name: TLinqProjection;
    function Address: TLinqProjection;
    function Email: TLinqProjection;
    function zip_id: Izip_codesDictionary;
  end;
  
  TcountriesDictionary = class(TAureliusEntityDictionary, IcountriesDictionary)
  public
    function Country_Id: TLinqProjection;
    function Country_Name: TLinqProjection;
  end;
  
  Tzip_codesDictionary = class(TAureliusEntityDictionary, Izip_codesDictionary)
  public
    function Zip_Id: TLinqProjection;
    function Zip_City_Name: TLinqProjection;
    function Zip_Code: TLinqProjection;
    function country_id: IcountriesDictionary;
  end;

  TListcontactsDictionary =class(TAureliusEntityDictionary,IList_contactsDictionary)
  public
    function Contact_id: TLinqProjection;
    function Name: TLinqProjection;
    function Address: TLinqProjection;
    function Email: TLinqProjection;
    function zip_id: TLinqProjection;
    function zip_city_name: TLinqProjection;
    function zip_code: TLinqProjection;
    function Country_Id: TLinqProjection;
    function Country_Name: TLinqProjection;
  end;

  IDictionary = interface(IAureliusDictionary)
    function contacts: IcontactsDictionary;
    function countries: IcountriesDictionary;
    function zip_codes: Izip_codesDictionary;
    function list_contacts: IList_contactsDictionary;
  end;

  TDictionary = class(TAureliusDictionary, IDictionary)
  public
    function contacts: IcontactsDictionary;
    function countries: IcountriesDictionary;
    function zip_codes: Izip_codesDictionary;
    function list_contacts: IList_contactsDictionary;
  end;

function Dic: IDictionary;

implementation

var
  __Dic: IDictionary;

function Dic: IDictionary;
begin
  if __Dic = nil then __Dic := TDictionary.Create;
  result := __Dic;
end;

{ Tcontacts }

function Tcontacts.Getzip_id: Tzip_codes;
begin
  result := Fzip_id.Value;
end;

procedure Tcontacts.Setzip_id(const Value: Tzip_codes);
begin
  Fzip_id.Value := Value;
end;

{ Tzip_codes }

function Tzip_codes.Getcountry_id: Tcountries;
begin
  result := Fcountry_id.Value;
end;

procedure Tzip_codes.Setcountry_id(const Value: Tcountries);
begin
  Fcountry_id.Value := Value;
end;

{ TcontactsDictionary }

function TcontactsDictionary.Contact_Id: TLinqProjection;
begin
  Result := Prop('Contact_Id');
end;

function TcontactsDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TcontactsDictionary.Address: TLinqProjection;
begin
  Result := Prop('Address');
end;

function TcontactsDictionary.Email: TLinqProjection;
begin
  Result := Prop('Email');
end;

function TcontactsDictionary.zip_id: Izip_codesDictionary;
begin
  Result := Tzip_codesDictionary.Create(PropName('zip_id'));
end;

{ TcountriesDictionary }

function TcountriesDictionary.Country_Id: TLinqProjection;
begin
  Result := Prop('Country_Id');
end;

function TcountriesDictionary.Country_Name: TLinqProjection;
begin
  Result := Prop('Country_Name');
end;

{ Tzip_codesDictionary }

function Tzip_codesDictionary.Zip_Id: TLinqProjection;
begin
  Result := Prop('Zip_Id');
end;

function Tzip_codesDictionary.Zip_City_Name: TLinqProjection;
begin
  Result := Prop('Zip_City_Name');
end;

function Tzip_codesDictionary.Zip_Code: TLinqProjection;
begin
  Result := Prop('Zip_Code');
end;

function Tzip_codesDictionary.country_id: IcountriesDictionary;
begin
  Result := TcountriesDictionary.Create(PropName('country_id'));
end;



{ TDictionary }

function TDictionary.contacts: IcontactsDictionary;
begin
  Result := TcontactsDictionary.Create;
end;

function TDictionary.countries: IcountriesDictionary;
begin
  Result := TcountriesDictionary.Create;
end;

function TDictionary.list_contacts: IList_contactsDictionary;
begin
  result:= TListcontactsDictionary.Create;
end;

function TDictionary.zip_codes: Izip_codesDictionary;
begin
  Result := Tzip_codesDictionary.Create;
end;

{ TListcontactsDictionary }

function TListcontactsDictionary.Address: TLinqProjection;
begin
  Result := Prop('Address');
end;

function TListcontactsDictionary.Contact_id: TLinqProjection;
begin
  Result := Prop('Contact_id');
end;

function TListcontactsDictionary.Country_Id: TLinqProjection;
begin
     Result := Prop('Country_Id');
end;

function TListcontactsDictionary.Country_Name: TLinqProjection;
begin
     Result := Prop('Country_Name');
end;

function TListcontactsDictionary.Email: TLinqProjection;
begin
      Result := Prop('Email');
end;

function TListcontactsDictionary.Name: TLinqProjection;
begin
      Result := Prop('Name');
end;

function TListcontactsDictionary.zip_city_name: TLinqProjection;
begin
     Result := Prop('zip_city_name');
end;

function TListcontactsDictionary.zip_code: TLinqProjection;
begin
     Result := Prop('zip_code');
end;

function TListcontactsDictionary.zip_id: TLinqProjection;
begin
      Result := Prop('zip_id');
end;

initialization
  RegisterEntity(Tcontacts);
  RegisterEntity(Tcountries);
  RegisterEntity(Tzip_codes);
  RegisterEntity(TList_contacts);

end.
