unit base64;
interface
uses system.Classes,system.SysUtils,System.NetEncoding,fmx.Graphics;

function BitmapToBase64(Bitmap: TBitmap): UnicodeString;
function Base64ToBitmap(const base64String: Unicodestring): TBitmap;
function Base64ToPDF(base64String: string): TBytes;

implementation
//--------------------------------------------------------------------------------------------
function BitmapToBase64(Bitmap: TBitmap): UnicodeString;
var
  Stream: TMemoryStream;
  Encoding: TNetEncoding;
  Output: TStringStream;
begin
  Encoding := TNetEncoding.Base64;
  Stream := TMemoryStream.Create;
  Output := TStringStream.Create;
  try
    Bitmap.SaveToStream(Stream);
    Stream.Position := 0;
    Encoding.Encode(Stream, Output);
    Result := Output.DataString;
  finally
    Output.Free;
    Stream.Free;
  end;
end;
//------------------------------------------------------------------------------
function Base64ToBitmap(const base64String: Unicodestring): TBitmap;
var
  decodedStream: TBytesStream;
  base64Decoder: TBase64Encoding;
begin
  decodedStream := nil;
  base64Decoder := TBase64Encoding.Create;
  try
    decodedStream := TBytesStream.Create(base64Decoder.DecodeStringToBytes(base64String));
    Result := TBitmap.Create;
    Result.LoadFromStream(decodedStream);
  finally
    decodedStream.Free;
    base64Decoder.Free;
  end;
end;

//------------------------------------------------------------------------------
function Base64ToPDF(base64String: string): TBytes;
var
  encoding: TBase64Encoding;
begin
  encoding := TBase64Encoding.Create;
  try
    Result := encoding.DecodeStringToBytes(base64String);
  finally
    encoding.Free;
  end;
end;

end.
