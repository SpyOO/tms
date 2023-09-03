program TMSRestServer;

uses
  System.StartUpCopy,
  FMX.Forms,
  uServerMain in 'uServerMain.pas' {Form1},
  contacts.model in 'models\contacts.model.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
