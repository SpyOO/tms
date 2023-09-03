unit Model.countries;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TValue = class
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
  
  TCountries = class(TJsonDTO)
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

{ TCountries }

destructor TCountries.Destroy;
begin
  GetValue.Free;
  inherited;
end;

function TCountries.GetValue: TObjectList<TValue>;
begin
  Result := ObjectList<TValue>(FValue, FValueArray);
end;

function TCountries.GetAsJson: string;
begin
  RefreshArray<TValue>(FValue, FValueArray);
  Result := inherited;
end;

end.
