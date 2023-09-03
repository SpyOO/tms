unit Model.contacts;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TCountryId = class;
  TZipId = class;

  TCountryId = class
  private
    [JSONName('Country_Id')]
    FCountryId: Integer;
    [JSONName('Country_Name')]
    FCountryName: string;
    [JSONName('$id')]
    FId: Integer;
  published
    property CountryId: Integer read FCountryId write FCountryId;
    property CountryName: string read FCountryName write FCountryName;
    property Id: Integer read FId write FId;
  end;
  
  TZipId = class
  private
    [JSONName('country_id')]
    FCountryId: TCountryId;
    [JSONName('$id')]
    FId: Integer;
    [JSONName('Zip_City_Name')]
    FZipCityName: string;
    [JSONName('Zip_Code')]
    FZipCode: string;
    [JSONName('Zip_Id')]
    FZipId: Integer;
  published
    property CountryId: TCountryId read FCountryId;
    property Id: Integer read FId write FId;
    property ZipCityName: string read FZipCityName write FZipCityName;
    property ZipCode: string read FZipCode write FZipCode;
    property ZipId: Integer read FZipId write FZipId;
  public
    constructor Create;
    destructor Destroy; override;
  end;
  
  TValue = class
  private
    FAddress: string;
    [JSONName('Contact_Id')]
    FContactId: Integer;
    FEmail: string;
    [JSONName('$id')]
    FId: Integer;
    FName: string;
    [JSONName('zip_id')]
    FZipId: TZipId;
  published
    property Address: string read FAddress write FAddress;
    property ContactId: Integer read FContactId write FContactId;
    property Email: string read FEmail write FEmail;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property ZipId: TZipId read FZipId;
  public
    constructor Create;
    destructor Destroy; override;
  end;
  
  TContact = class(TJsonDTO)
  private
    [JSONName('value'), JSONMarshalled(False)]
    FValueArray: TArray<TValue>;
    [GenericListReflect]
    FValue: TObjectList<TValue>;
    function GetValue: TObjectList<TValue>;
  protected
    function GetAsJson: string; override;
  published
    property Value: TObjectList<TValue> read GetValue;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TZipId }

constructor TZipId.Create;
begin
  inherited;
  FCountryId := TCountryId.Create;
end;

destructor TZipId.Destroy;
begin
  FCountryId.Free;
  inherited;
end;

{ TValue }

constructor TValue.Create;
begin
  inherited;
  FZipId := TZipId.Create;
end;

destructor TValue.Destroy;
begin
  FZipId.Free;
  inherited;
end;

{ TRoot }

destructor TContact.Destroy;
begin
  GetValue.Free;
  inherited;
end;

function TContact.GetValue: TObjectList<TValue>;
begin
  Result := ObjectList<TValue>(FValue, FValueArray);
end;

function TContact.GetAsJson: string;
begin
  RefreshArray<TValue>(FValue, FValueArray);
  Result := inherited;
end;

end.
