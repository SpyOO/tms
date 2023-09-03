unit uCombobox;
interface
uses FMX.Layouts, FMX.Objects, FMX.Types, FMX.Forms, FMX.Graphics, FMX.Ani,
     FMX.StdCtrls, SysUtils, System.Types;
type
  TExecutaClickWin = procedure(Sender: TObject) of Object;
  TExecutaClickMobile = procedure(Sender: TObject; const Point: TPointF) of Object;
  TCustomCombo = class
  private
    rectFundo, rectItem: TRectangle;
    vert : TVertScrollBox;
    ani : TFloatAnimation;
    btnBack : TSpeedButton;
    lblTitulo, lblSubTitulo, lblItem : TLabel;
    FTitleMenuText, FSubTitleMenuText, FCodItem, FDescrItem : string;
    fValueFloat:Real;
    fAdicValue:string;
    FTitleFontSize, FItemFontSize, FSubTitleFontSize, FSubItemFontSize : integer;
    FBackgroundColor, FTitleFontColor, FSubTitleFontColor, FItemFontColor, FItemBackgroundColor : Cardinal;
    FVisible : Boolean;
    {$IFDEF MSWINDOWS}
    ACallBack: TExecutaClickWin;
    {$ELSE}
    ACallBack: TExecutaClickMobile;
    {$ENDIF}
  public
    constructor Create(Frm: TForm);
    procedure ShowMenu();
    procedure ClickCancel(Sender: TObject);
    procedure HideMenu();
    procedure FinishFade(Sender: TObject);
    procedure ProcessFade(Sender: TObject);
    procedure AddItem(codItem: string; itemText: string;ValueAdic:string);
    procedure ClearItems;
    procedure CreateVert;
    {$IFDEF MSWINDOWS}
    procedure ItemClick(Sender: TObject);
    {$ELSE}
    procedure ItemClick(Sender: TObject; const Point: TPointF);

    {$ENDIF}
         //  procedure AfterConstruction; override;
  published
    property TitleMenuText: string read FTitleMenuText write FTitleMenuText;
    property TitleFontSize: integer read FTitleFontSize write FTitleFontSize;
    property TitleFontColor: Cardinal read FTitleFontColor write FTitleFontColor;
    property SubTitleMenuText: string read FSubTitleMenuText write FSubTitleMenuText;
    property SubTitleFontSize: integer read FSubTitleFontSize write FSubTitleFontSize;
    property SubTitleFontColor: Cardinal read FSubTitleFontColor write FSubTitleFontColor;
    property ItemFontSize: integer read FItemFontSize write FItemFontSize;
    property ItemFontColor: Cardinal read FItemFontColor write FItemFontColor;
    property ItemBackgroundColor: Cardinal read FItemBackgroundColor write FItemBackgroundColor;
    property BackgroundColor: Cardinal read FBackgroundColor write FBackgroundColor;
    property Visible: Boolean read FVisible write FVisible;
    property CodItem: String read FCodItem write FCodItem;
    property DescrItem: String read FDescrItem write FDescrItem;

    property ValueFloat: real  read fValueFloat write fValueFloat;
    property AdicValue:string read fAdicValue write fAdicValue;
    {$IFDEF MSWINDOWS}
    property OnClick: TExecutaClickWin read ACallBack write ACallBack;
    {$ELSE}
    property OnClick: TExecutaClickMobile read ACallBack write ACallBack;
    {$ENDIF}

end;

implementation

constructor TCustomCombo.Create(Frm: TForm);
begin
    FTitleMenuText := 'Seleccione una opci�n';
    FTitleFontSize := 18;
    FTitleFontColor := $FF1F2035;
    FSubTitleMenuText := '';
    FSubTitleFontSize := 15;
    FSubTitleFontColor := $FF000000;
    FItemFontSize := 15;
    FItemFontColor := $FF1F2035;
    FItemBackgroundColor := $FFFFFFFF;

    FBackgroundColor := $FFFFFFFF;

    // Crea rect del fondo...
    rectFundo := TRectangle.Create(Frm);
    with rectFundo do
    begin
        Align := TAlignLayout.Contents;
        Fill.Kind := TBrushKind.Solid;
        Fill.Color := FBackgroundColor;
        BringToFront;
        HitTest := false;
        Margins.Right := (Frm.Width + 100) * -1;
        Visible := false;
        Stroke.Kind := TBrushKind.None;
        Padding.Left := 20;
        Padding.Right := 20;
        Tag := 0;
    end;
    Frm.AddObject(rectFundo);

    // Crea animaci�n del entrada...
    ani := TFloatAnimation.Create(rectFundo);
    with ani do
    begin
        PropertyName := 'Margins.Right';
        StartValue := (Frm.Width + 100) * -1;
        StopValue := 0;
        Inverse := false;
        Duration := 0.3;
        OnFinish := FinishFade;
        OnProcess := ProcessFade;
    end;
    rectFundo.AddObject(ani);

    // Label con titulo de la pantalla...
    lblTitulo := TLabel.Create(rectFundo);
    with lblTitulo do
    begin
        Text := FTitleMenuText;
        Align := TAlignLayout.MostTop;
        Height := 50;
        VertTextAlign := TTextAlign.Center;
        TextAlign := TTextAlign.Center;
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
        Font.Size := FTitleFontSize;
        FontColor := FTitleFontColor;
        //AutoSize := true;
        Margins.Top := 0;
        Margins.Bottom := 0;
    end;
    rectFundo.AddObject(lblTitulo);

    // Label com subtitulo da tela...
    lblSubTitulo := TLabel.Create(rectFundo);
    with lblSubTitulo do
    begin
        Text := FSubTitleMenuText;
        Align := TAlignLayout.MostTop;
        Height := 20;
        VertTextAlign := TTextAlign.Center;
        TextAlign := TTextAlign.Center;
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
        Font.Size := FSubTitleFontSize;
        FontColor := FSubTitleFontColor;
        //AutoSize := true;
        Margins.Top := 0;
        Margins.Bottom := 0;
    end;
    rectFundo.AddObject(lblSubTitulo);

 CreateVert ; //Voler a copiar luego

    // Bot�n volcer...
    btnBack := TSpeedButton.Create(rectFundo);
    with btnBack do
    begin
        Width := 48;
        Height := 48;
        Position.X := 13;
        Position.Y := 5;
        BringToFront;
        StyleLookup := 'backtoolbutton';
        Text := '';
        OnClick := ClickCancel;
    end;
    rectFundo.AddObject(btnBack);

end;
procedure TCustomCombo.CreateVert;
begin
      // Layout que contiene el bot�n cancelar...
    vert := TVertScrollBox.Create(rectFundo);
    with vert do
    begin
        Align := TAlignLayout.Client;
        ShowScrollBars := false;
        Margins.Top := 20;
        Margins.Bottom := 20;
        Visible := true;
    end;
    rectFundo.AddObject(vert);
end;

procedure TCustomCombo.ClearItems;

begin
  vert.Free;
  CreateVert;
end;
//---------------------------------------------------------------------------------------------------------------------
procedure TCustomCombo.ClickCancel(Sender: TObject);
begin
    FCodItem := '';
    FDescrItem := '';
    fAdicValue:='';
    HideMenu;
end;
{$IFDEF MSWINDOWS}
procedure TCustomCombo.ItemClick(Sender: TObject);
begin
    FCodItem := TLabel(Sender).TagString;
    FDescrItem := TLabel(Sender).Text;
    FValueFloat :=Tlabel(Sender).TagFloat;
    fAdicValue :=(TLabel(Sender).Parent As TRectangle).TagString;
    ACallBack(Sender);
end;
{$ELSE}
procedure TCustomCombo.ItemClick(Sender: TObject; const Point: TPointF);
begin
    FCodItem := TLabel(Sender).TagString;
    FDescrItem := TLabel(Sender).Text;
    FValueFloat :=Tlabel(Sender).TagFloat;
    ACallBack(Sender, Point);
end;
{$ENDIF}
procedure TCustomCombo.ShowMenu();
begin
    //  retorna scroll para el inicio...
    vert.ViewportPosition := TPointF.Zero;
    // Coloca el  fondo opaco...
    rectFundo.Visible := true;
    FVisible := true;
    rectFundo.Fill.Color := FBackgroundColor;
    ani.Inverse := false;
    ani.Start;

    // Titulo del menu...
    if Trim(FTitleMenuText) = '' then
        lblTitulo.Height := 0
    else
    begin
        lblTitulo.Height := 50;
        lblTitulo.Margins.Top := 50;
        lblTitulo.Margins.Bottom := 10;
    end;
    lblTitulo.Font.Size := FTitleFontSize;
    lblTitulo.Text := FTitleMenuText;
    //  subtitulo del menu...
    if Trim(FSubTitleMenuText) = '' then
        lblSubTitulo.Height := 0
    else
    begin
        lblSubTitulo.Height := 20;
        if lblTitulo.Height > 0 then
            lblSubTitulo.Margins.Top := 10
        else
            lblSubTitulo.Margins.Top := 50;
        lblSubTitulo.Margins.Bottom := 10;
    end;
    lblSubTitulo.Font.Size := FSubTitleFontSize;
    lblSubTitulo.Text := FSubTitleMenuText;
end;
procedure TCustomCombo.AddItem(codItem: string; itemText: string; ValueAdic:string);
begin
    // Fondo del item...
    rectItem := TRectangle.Create(vert);
    with rectItem do
    begin
        Align := TAlignLayout.MostTop;
        Fill.Kind := TBrushKind.Solid;
        Fill.Color := FItemBackgroundColor;
        RectItem.TagString:=ValueAdic;
        HitTest := true;
        XRadius := 6;
        YRadius := 6;
        Margins.Bottom := 10;
        Height := 60;
        Stroke.Kind := TBrushKind.None;
    end;
    vert.AddObject(rectItem);

    lblItem := TLabel.Create(rectItem);
    with lblItem do
    begin
        Text := itemText;
        Align := TAlignLayout.Client;
        VertTextAlign := TTextAlign.Center;
        lblItem.Tagstring:='XD';
        TextAlign := TTextAlign.Leading;
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
        Font.Size := FItemFontSize;
        FontColor := FItemFontColor;
        HitTest := true;
        Margins.Left := 10;
        Margins.Right := 10;
        TagString := codItem;

        {$IFDEF MSWINDOWS}
        OnClick := ItemClick;
        {$ELSE}
        OnTap := ItemClick;
        {$ENDIF}
    end;
    rectItem.AddObject(lblItem);
    vert.Repaint;
end;
procedure TCustomCombo.FinishFade(Sender: TObject);
begin
    rectFundo.Visible := FVisible;
end;
procedure TCustomCombo.ProcessFade(Sender: TObject);
begin
    rectFundo.Margins.Left := rectFundo.Margins.Right * -1;
end;
procedure TCustomCombo.HideMenu();
begin
    FVisible := false;
    ani.Delay := 0;
    ani.Inverse := true;
    ani.Start;
end;

end.