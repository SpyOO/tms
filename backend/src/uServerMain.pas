unit uServerMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,system.DateUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Sparkle.HttpServer.Module, Sparkle.HttpServer.Context,
  XData.Server.Module, Aurelius.Drivers.Interfaces, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Aurelius.Comp.Connection, Data.DB, FireDAC.Comp.Client, XData.Comp.ConnectionPool,
  Sparkle.Comp.Server, Sparkle.Comp.HttpSysDispatcher, XData.Comp.Server, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  Aurelius.Sql.MySQL, Aurelius.Schema.MySQL, Aurelius.Drivers.FireDac, FMX.Memo.Types, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.Edit, FMX.Objects;

type
  TForm1 = class(TForm)
    XDataServer: TXDataServer;
    SpkHttpDispatcher: TSparkleHttpSysDispatcher;
    XDataConnPool: TXDataConnectionPool;
    FDConn: TFDConnection;
    AureliusConn: TAureliusConnection;
    lay_top: TLayout;
    MemoLog: TMemo;
    Layout2: TLayout;
    grp_mysql: TGroupBox;
    edt_mySql_Host: TEdit;
    lbl_mysql_host: TLabel;
    lbl_mysql_port: TLabel;
    edt_mysql_port: TEdit;
    lbl_mysql_database: TLabel;
    edt_mysql_database: TEdit;
    lbl_mysql_username: TLabel;
    edt_mysql_username: TEdit;
    lbl_mysql_password: TLabel;
    edt_mysql_password: TEdit;
    rec_StartStop_server: TCircle;
    txt_rec: TText;
    procedure txt_recClick(Sender: TObject);
    procedure SpkHttpDispatcherStart(Sender: TObject);
    procedure SpkHttpDispatcherStop(Sender: TObject);
    procedure XDataServerEntityList(Sender: TObject; Args: TEntityListArgs);
    procedure XDataServerEntityInserting(Sender: TObject; Args: TEntityInsertingArgs);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure StartServer;
    procedure StopServer;
    procedure writelog(const aMsg:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if SpkHttpDispatcher.Active then
   SpkHttpDispatcher.Active:=false;

end;

procedure TForm1.SpkHttpDispatcherStart(Sender: TObject);
begin
 writeLog('Server started');
 rec_StartStop_server.Fill.Color:=TAlphaColors.Black;
 {Set the tag property to indicate that the start button was pressed'}
 rec_StartStop_server.TagString:='YES';
 txt_rec.Text:='STOP';
end;

procedure TForm1.SpkHttpDispatcherStop(Sender: TObject);
begin
  writeLog('Server stopped');
  FDConn.Connected:=false;
  rec_StartStop_server.Fill.Color:=TAlphaColors.Tomato;
 {Set the tag property to indicate that the start button was pressed'}
  rec_StartStop_server.TagString:='NO';
  txt_rec.Text:='START';
end;

procedure TForm1.StartServer;
begin
 try
   {setup mysql connection}
   FDConn.Connected:=false;
   FDConn.Params.Clear;
   FDConn.Params.Add('Port='   + edt_mysql_port.Text);
   FDConn.Params.Add('Server=' + edt_mySql_Host.Text);
   FDConn.Params.Values['DriverID'] := 'MYSQL';
   FDConn.Params.Values['Database'] := edt_mysql_database.Text;;
   FDConn.Params.Values['User_name']:= edt_mysql_username.Text;
   FDConn.Params.Values['Password'] := edt_mysql_password.Text;
   FDConn.Connected:=true;

   MemoLog.Lines.Clear;
   SpkHttpDispatcher.active:=true;
 except on E:exception do
   begin
    writeLog( E.Message);
    stopServer;
   end;
 end;
end;

procedure TForm1.StopServer;
begin
  SpkHttpDispatcher.active:=false;
end;

procedure TForm1.txt_recClick(Sender: TObject);
begin
 if Not SpkHttpDispatcher.Active then
    StartServer
 else
    StopServer;
end;
//--------------------------------------------------------------------------------------------------
procedure TForm1.writelog(const aMsg: string);
begin
 MemoLog.Lines.Add( format('[%s]: %s',[FormatDateTime('yyyy-mm-dd hh:nn:ss', now) ,aMsg] ));
end;

procedure TForm1.XDataServerEntityInserting(Sender: TObject; Args: TEntityInsertingArgs);
begin
  writelog( 'Inserting data');
end;

procedure TForm1.XDataServerEntityList(Sender: TObject; Args: TEntityListArgs);
begin
  writelog( 'Listing result');
end;

end.
