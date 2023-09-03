program FMX_Sparkle_Server;

uses
  System.StartUpCopy,
  FMX.Forms,
  uServer in 'uServer.pas',
  uMainFormFMX in 'uMainFormFMX.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
