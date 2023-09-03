unit Model.cities;

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
    [JSONName('$id')]
    FId: Integer;
  published
    property CountryId: Integer read FCountryId write FCountryId;
    property CountryName: string read FCountryName write FCountryName;
    property Id: Integer read FId write FId;
  end;
  
  TValue = class
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
  
  TCities = class(TJsonDTO)
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

{ TValue }

constructor TValue.Create;
begin
  inherited;
  FCountryId := TCountryId.Create;
end;

destructor TValue.Destroy;
begin
  FCountryId.Free;
  inherited;
end;

{ TRoot }

destructor TCities.Destroy;
begin
  GetValue.Free;
  inherited;
end;

function TCities.GetValue: TObjectList<TValue>;
begin
  Result := ObjectList<TValue>(FValue, FValueArray);
end;

function TCities.GetAsJson: string;
begin
  RefreshArray<TValue>(FValue, FValueArray);
  Result := inherited;
end;

end.
