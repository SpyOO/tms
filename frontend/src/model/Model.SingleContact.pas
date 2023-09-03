unit Model.SingleContact;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TCountryId = class;

  TCountryId = class
  private
    [JSONName('Country_Id')]
    FCountryId: Integer;
    [JSONName('Country_Name')]
    FCountryName: string;
  published
    property CountryId: Integer read FCountryId write FCountryId;
    property CountryName: string read FCountryName write FCountryName;
  end;
  
  TZipId = class
  private
    [JSONName('country_id')]
    FCountryId: TCountryId;
    [JSONName('Zip_City_Name')]
    FZipCityName: string;
    [JSONName('Zip_Code')]
    FZipCode: string;
    [JSONName('Zip_Id')]
    FZipId: Integer;
  published
    property CountryId: TCountryId read FCountryId;
    property ZipCityName: string read FZipCityName write FZipCityName;
    property ZipCode: string read FZipCode write FZipCode;
    property ZipId: Integer read FZipId write FZipId;
  public
    constructor Create;
    destructor Destroy; override;
  end;
  
  TSingleContact = class(TJsonDTO)
  private
    FAddress: string;
    [JSONName('Contact_Id')]
    FContactId: Integer;
    FEmail: string;
    FName: string;
    [JSONName('zip_id')]
    FZipId: TZipId;
  published
    property Address: string read FAddress write FAddress;
    property ContactId: Integer read FContactId write FContactId;
    property Email: string read FEmail write FEmail;
    property Name: string read FName write FName;
    property ZipId: TZipId read FZipId;
  public
    constructor Create; override;
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

{ TRoot }

constructor TSingleContact.Create;
begin
  inherited;
  FZipId := TZipId.Create;
end;

destructor TSingleContact.Destroy;
begin
  FZipId.Free;
  inherited;
end;

end.
