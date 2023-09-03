program ContactList;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  Frame.Contact in 'Frames\Frame.Contact.pas' {FrameContact: TFrame},
  model.contacts in 'model\model.contacts.pas',
  Pkg.Json.DTO in 'model\Pkg.Json.DTO.pas',
  ws_request in 'ws\ws_request.pas',
  uEditContact in 'uEditContact.pas' {FEditContact},
  uCombobox in 'utils\uCombobox.pas',
  Model.countries in 'model\Model.countries.pas',
  Model.cities in 'model\Model.cities.pas',
  Model.SingleContact in 'model\Model.SingleContact.pas',
  validator in 'utils\validator.pas',
  uFancyDialog in 'utils\uFancyDialog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  //Application.CreateForm(TFEditContact, FEditContact);
  Application.Run;
end.
