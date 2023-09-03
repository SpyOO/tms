unit validator;
interface
 uses system.RegularExpressions;
 function IsValidEmail(const Email: string): Boolean;
implementation
 function IsValidEmail(const Email: string): Boolean;
const
  EmailRegex = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
var
  Regex: TRegEx;
begin
  Regex := TRegEx.Create(EmailRegex);
  Result := Regex.IsMatch(Email);
end;

end.
