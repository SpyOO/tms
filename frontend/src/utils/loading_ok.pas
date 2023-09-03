unit Loading_ok;
interface
uses System.SysUtils, System.UITypes, FMX.Types, FMX.Controls, FMX.StdCtrls,
     FMX.Objects, FMX.Effects, FMX.Layouts, FMX.Forms, FMX.Graphics, FMX.Ani,
     FMX.VirtualKeyboard, FMX.Platform,system.Classes;
type
  TLoadingOK = class
    private
          class var Layout : TLayout;
          class var Fundo : TRectangle;
          class var Arco : TArc;
          class var Mensagem : TLabel;
          class var Animacao : TFloatAnimation;
          class var Image    : TImage;

    public
          class procedure Show(const Frm : Tform; const msg,img : string;ClickAble:boolean=true);
          class procedure Hide;
          class procedure ChangeText(const Text:string);
          class procedure OnClickFundo(sender:TObject);


  end;
implementation
{ TLoadingOK }

class procedure TLoadingOK.ChangeText(const Text: string);
begin
  Mensagem.Text:=Text;
end;

class procedure TLoadingOK.Hide;
begin
        if Assigned(Layout) then
        begin
                try
                        if Assigned(Mensagem) then
                                Mensagem.DisposeOf;
                        if Assigned(Animacao) then
                                Animacao.DisposeOf;
                        if Assigned(Arco) then
                                Arco.DisposeOf;
                        if Assigned(Fundo) then
                                Fundo.DisposeOf;
                        if Assigned(Image) then
                          Image.DisposeOf;

                        if Assigned(Layout) then
                                Layout.DisposeOf;



                except
                end;
        end;
        Mensagem := nil;
        Animacao := nil;
        Image    :=nil;
        Arco := nil;
        Layout := nil;
        Fundo := nil;
end;



class procedure TLoadingOK.OnClickFundo(sender: TObject);
begin
  Hide;
end;
//------------------------------------------------------------------------------
class procedure TLoadingOK.Show(const Frm : Tform; const msg,img: string;ClickAble:boolean=true);
var
        FService: IFMXVirtualKeyboardService;

begin
        // Panel de fundo opaco...
        Fundo := TRectangle.Create(Frm);
        Fundo.Opacity := 0;
        Fundo.Parent := Frm;
        Fundo.Visible := true;
        Fundo.Align := TAlignLayout.Contents;
        Fundo.Fill.Color := TAlphaColorRec.Black;
        Fundo.Fill.Kind := TBrushKind.Solid;
        Fundo.Stroke.Kind := TBrushKind.None;
        Fundo.Visible := true;

        if ClickAble then
          Fundo.OnClick :=OnClickFundo;

        // Layout contendo o texto e o arco...
        Layout := TLayout.Create(Frm);
        Layout.Opacity := 0;
        Layout.Parent := Frm;
        Layout.Visible := true;
        Layout.Align := TAlignLayout.Contents;
        Layout.Width := 250;
        Layout.Height := 78;
        Layout.Visible := true;
        // Arco da animacao...


        // Label do texto...

        Image :=TImage.Create(frm);
        Image.Parent:= Layout;
        Image.Align :=  TAlignLayout.Center;
        Image.Margins.Bottom:=50;
        Image.Width :=  Frm.Width - 100;
        Image.Height:= 120;
        Image.Bitmap.LoadFromFile(img);
        Image.HitTest:=False;


        Mensagem := TLabel.Create(Frm);
        Mensagem.Parent := Layout;
        Mensagem.Align := TAlignLayout.Center;
        Mensagem.Margins.Top := Image.Height + 50;
        Mensagem.Font.Size := 15;
        Mensagem.Height := 70;
        Mensagem.Width := Frm.Width - 100;
        Mensagem.FontColor := $FFFEFFFF;
        Mensagem.TextSettings.HorzAlign := TTextAlign.Center;
        Mensagem.TextSettings.VertAlign := TTextAlign.Leading;
        Mensagem.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
        Mensagem.Text := msg;
        Mensagem.VertTextAlign := TTextAlign.Leading;
        Mensagem.Trimming := TTextTrimming.None;
        Mensagem.TabStop := false;
        Mensagem.SetFocus;




        // Exibe os controles...
        Fundo.AnimateFloat('Opacity', 0.7);
        Layout.AnimateFloat('Opacity', 1);
        Layout.BringToFront;
        // Esconde o teclado virtual...
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                          IInterface(FService));
        if (FService <> nil) then
        begin
            FService.HideVirtualKeyboard;
        end;
        FService := nil;
end;

end.
