unit Frame.Contact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TFrameContact = class(TFrame)
    rectFundo: TRectangle;
    imgPicture: TImage;
    ImgEdit: TImage;
    Layout1: TLayout;
    lblCity: TLabel;
    lblName: TLabel;
    imgDelete: TImage;
  private
    FId_contact: integer;
    FName: string;
    { Private declarations }
  public
    property id_contact: integer read FId_contact write FId_contact;
    property name: string read FName write FName;
  end;

implementation

{$R *.fmx}

end.
