unit SalesGraphicWeb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, ExtCtrls, Graphics, Dialogs, TypInfo,
  StrUtils, LResources, db, JsonTools,openssl, opensslsockets,  graphicwebconst;

////////////////////////TSalesGraphicWeb///////////////////////////
//   Desenvolvedor: Humberto Sales                               //
//   Email        : humbertoliveira@hotmail.com                  //
//                  humbertosales@midassistemas.com.br           //
//   Telegram     : https://t.me/lazarusfreepascal1 {brasil}     //
//   Colaboradores:                                              //
//        *                                                      //
//        *                                                      //
//        *                                                      //
//                                                               //
///////////////////////////////////////////////////////////////////


const
 Creative    : array[0..10] of TColor = ($b62b6e,$9628c6,$4374b7,$abb8af,$98c807,$b1a24a,$edd812,$ef9421,$d13814,$004eaf,$2db928);
 Continental : array[0..10] of TColor = ($ffa500,$00a5dc,$004eaf,$2db928,$057855,$f0f0f0,$ff2d37,$cdcdcd,$000000,$737373,$969696);
 Deezer      : array[0..10] of TColor = ($ff0000,$ffed00,$ff0092,$c2ff00,$00c7f2,$c1f1fc,$ebffac,$ffc2e5,$ffaaaa,$004eaf,$2db928);
 Delectable  : array[0..10] of TColor = ($334858,$cd595a,$94938f,$a3a7a6,$dbc5b0,$f8dfc2,$f9ebdf,$ffc2e5,$ffaaaa,$004eaf,$2db928);
 Dell        : array[0..10] of TColor = ($0085c3,$7ab800,$f2af00,$dc5034,$ce1126,$b7295a,$6e2585,$71c6c1,$5482ab,$009bbb,$444444);
 DinDR       : array[0..10] of TColor = ($fdb94e,$f9a852,$f69653,$f38654,$f07654,$ed6856,$ef5956,$ee4c58,$56c1ab,$6a6b6a,$009bbb);


type
  TGraphicType = (bar,line,radar,pie,doughnut,polarArea,scatter,bubble,radialGauge,violin,sparkline,progressBar,horizontalBar);

  ESalesGraphicWeb = Class(Exception);

  TLegendPosition = (LpLeft,LpRight,Lptop,Lpbottom,LpChartArea);
  TGrPosition  = (grStart, grCenter, grend);
  TGrAlign     = (center, top, bottom, left, right);
  TGrFontStyle = (normal,bold,italic);
  TDirection   = (drRow,drCol);

  TStyle = (SNone,SCreative,SContinental,SDeezer,SDelectable,SDell,SDindr);

  { TBarGraphics }

  { TDesenvolvedor }

  TDeveloper = class(TPersistent)
  private
    FEmail: String;
    FName: String;
    FTelegram: String;
    FTelegramGroup: String;
    FVersion: String;
  public
     constructor Create;
  published
     property Name          : String read FName;
     property Email         : String read FEmail;
     property Version       : String read FVersion;
     property Telegram      : String read FTelegram;
     property TelegramGroup : String read FTelegramGroup;
  end;

  TBarGraphics = Class(TPersistent)
  private
    FroundedBars: boolean;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property roundedBars : boolean read FroundedBars write FroundedBars;
  end;

  ThorizontalBar = Class(TBarGraphics);
  TBarGraphic    = Class(TBarGraphics);

  { TDoughnutGraphic }

  TDoughnutGraphic = Class(TPersistent)
  private
    FActive: boolean;
    FFontSize: integer;
    FSubTitle: string;
    FTitle: string;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property active   : boolean read FActive    write FActive;
    property Title    : string  read FTitle     write FTitle;
    property FontSize : integer read FFontSize  write FFontSize;
    property SubTitle : string  read FSubTitle  write FSubTitle;
  end;


  { TLineGraphic }

  TLineGraphic = Class(TPersistent)
  private
    FborderDash_C: byte;
    FborderDash_E: byte;
    FFill: boolean;
    FpointRadius: byte;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property fill             : boolean read FFill         write FFill;
    property borderDash_C     : byte    read FborderDash_C write FborderDash_C;
    property borderDash_E     : byte    read FborderDash_E write FborderDash_E;
    property pointRadius      : byte    read FpointRadius  write FpointRadius;
  end;

  { TGraphicOptions }

  TGraphicOptions = Class(TPersistent)
  private
    FBarGraphic: TBarGraphic;
    FDoughnutGraphic: TDoughnutGraphic;
    FhorizontalBar: ThorizontalBar;
    FLineGraphic: TLineGraphic;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property DoughnutGraphic : TDoughnutGraphic read FDoughnutGraphic write FDoughnutGraphic;
    property BarGraphic      : TBarGraphic      read FBarGraphic      write FBarGraphic;
    property HorizontalBar   : ThorizontalBar   read FhorizontalBar   write FhorizontalBar;
    property LineGraphic     : TLineGraphic     read FLineGraphic     write FLineGraphic;
  end;


  TTitle = Class(TPersistent)
  private
    Fdisplay: boolean;
    Ffontcolor: TColor;
    Ffontsize: byte;
    Ffontstyle: TGrFontStyle;
    Fposition: TGrAlign;
    Ftext: string;
  public
    constructor create;
    destructor Destroy; override;
  published
    property display   : boolean      read Fdisplay   write Fdisplay;
    property text      : string       read Ftext      write Ftext;
    property fontsize  : byte         read Ffontsize  write Ffontsize;
    property fontstyle : TGrFontStyle read Ffontstyle write Ffontstyle;
    property fontcolor : TColor       read Ffontcolor write Ffontcolor;
    property position  : TGrAlign     read Fposition  write Fposition;
  end;

  { TLegend }

  TLegend = Class(TPersistent)
  private
    Falign    : TGrPosition;
    Fposition : TLegendPosition;
    FVisible  : boolean;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Visible : boolean         read FVisible  write FVisible ;
    property position: TLegendPosition read Fposition write Fposition;
    property align   : TGrPosition     read Falign    write Falign;
  end;

  { TSerie }

  TSerie = Class(TPersistent)
  private
    FActive: Boolean;
    FborderColor: TColor;
    FborderWidth: byte;
    FStyle: TStyle;
    FTransparency: byte;
    procedure SetTransparency(AValue: byte);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Active          : Boolean read FActive       write FActive;
    property Transparency    : byte    read FTransparency write SetTransparency;
    property borderColor     : TColor  read FborderColor  write FborderColor;
    property boderWidth      : byte    read FborderWidth  write FborderWidth;
    property Style           : TStyle  read FStyle        write FStyle;
  end;


  { TTicks }

  TTicks = Class(TPersistent)
  private
    Fmax     : byte;
    Fmin     : byte;
    FstepSize: byte;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property min      : byte read Fmin      write Fmin;
    property max      : byte read Fmax      write Fmax;
    property stepSize : byte read FstepSize write FstepSize;
  end;

  { TScaleLabel }

  TScaleLabel = Class(TPersistent)
  private
    Fdisplay: boolean;
    FlabelString: string;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property display     : boolean read Fdisplay     write Fdisplay;
    property labelString : string  read FlabelString write FlabelString;
  end;

  { TAxis }

  TAxis = Class(TPersistent)
  private
    FScalelabel: TScalelabel;
    Fticks: TTicks;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property ScaleLabel : TScalelabel read FScalelabel write FScalelabel;
    property Ticks      : TTicks      read Fticks      write Fticks;
  end;

  { TScales }

  TScales = Class(TPersistent)
  private
    FxAxes: TAxis;
    FyAxes: TAxis;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property xAxes   : TAxis read FxAxes write FxAxes;
    property yAxes   : TAxis read FyAxes write FyAxes;
  end;


  { OutLabelFonts }

  TOutLabelFonts = class(TPersistent)
  private
    FmaxSize: integer;
    FminSize: integer;
    FResizable: boolean;
  public
    constructor Create;
  published
    property Resizable : boolean read FResizable write FResizable;
    property minSize   : integer read FminSize   write FminSize;
    property maxSize   : integer read FmaxSize   write FmaxSize;
  end;

  TOutLabels = Class(TPersistent)
  private
    FColor: TColor;
    FDisplay: Boolean;
    FFont: TOutLabelFonts;
    FStretch: integer;
    FText: string;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Display : Boolean        read FDisplay write FDisplay;
    property Text    : string         read FText    write FText;
    property Color   : TColor         read FColor   write FColor;
    property stretch : integer        read FStretch write FStretch;
    property Font    : TOutLabelFonts read FFont    write FFont;
  end;

  { TDataLabels }

  TDataLabels = Class(TPersistent)
  private
    Falign: TGrAlign;
    Fcolor: TColor;
    FDisplay: Boolean;
  public
    constructor Create;
  published
    property Display : Boolean  read FDisplay write FDisplay; {sem relacoes com o grafico...}
    property Align   : TGrAlign read Falign   write Falign;
    property Color   : TColor   read Fcolor   write Fcolor;
  end;


  { TPlugins }

  TPlugins = Class(TPersistent)
  private
    FDataLabels: TDataLabels;
    FOutLabels: TOutLabels;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property OutLabels  : TOutLabels  read FOutLabels  write FOutLabels;
    property DataLabels : TDataLabels read FDataLabels write FDataLabels;
  end;

  { TOptions }

  TOptions = Class(TPersistent)
  private
    FLegend : TLegend;
    FPlugins: TPlugins;
    FScale  : TScales;
    FTitle  : TTitle;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Title   : TTitle   read FTitle   write FTitle;
    property Legend  : TLegend  read FLegend  write FLegend;
    property Scale   : TScales  read FScale   write FScale;
    property Plugins : TPlugins read FPlugins write FPlugins;
  end;

  { TColorStyle }

  TColorStyle = Class(TPersistent)
  private
    FBackgroundColor: TColor;
    FStyle: TStyle;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property backgroundColor : TColor read FBackgroundColor write FBackgroundColor;
    property Style           : TStyle read FStyle           write FStyle;
  end;

  { TDataSets }

  TDataSets = Class(TPersistent)
  private
    FActive: Boolean;
    FborderColor: TColor;
    FborderWidth: byte;
    FColorStyle: TColorStyle;
    FGraphicType: TGraphicType;
    FTransparency: byte;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Active       : Boolean      read FActive       write FActive;
    property GraphicType  : TGraphicType read FGraphicType  write FGraphicType;
    property ColorStyle   : TColorStyle  read FColorStyle   write FColorStyle;
    property Transparency : byte         read FTransparency write FTransparency;
    property borderColor  : TColor       read FborderColor  write FborderColor;
    property boderWidth   : byte         read FborderWidth  write FborderWidth;
  end;

  { TSalesGraphicWeb }

  TSalesGraphicWeb = Class(TCustomImage)
  private
    FBackGroundColor: TColor;
    FDeveloper: TDeveloper;
    FDirection: TDirection;
    FGraphicHeight: integer;
    FGraphicOptions: TGraphicOptions;
    FGraphicType: TGraphicType;
    FGraphicWidth: integer;
    FLegend: TLegend;
    FLink : String;
    FOptions: TOptions;
    FPlugins: TPlugins;
    FSerie: TSerie;
    FDataSet : TDataSet;
    const
    Link =   'http://quickchart.io/chart?%s&%s&%s&c=';
    function ColorToHex(FColor: TColor): String;
    function ColorToRGBA(FColor: TColor; FTransparency: byte): String;
    function CreateLink(DataSet: TDataSet; LineCol: TDirection; FGraphic: string): String;
    function removeAspas(AJson: String): String;
    function SendLink(ALink: String): String;
    procedure SetBackGroundColor(AValue: TColor);
    procedure SetGraphicHeight(AValue: integer);
    procedure SetGraphicType(AValue: TGraphicType);
    procedure SetGraphicWidth(AValue: integer);
    procedure SendError(FTexto: String);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show;

  published
    property GraphicWidth      : integer         read FGraphicWidth    write SetGraphicWidth;
    property GraphicHeight     : integer         read FGraphicHeight   write SetGraphicHeight;
    property GraphicType       : TGraphicType    read FGraphicType     write SetGraphicType;
    property BackGroundColor   : TColor          read FBackGroundColor write SetBackGroundColor;
    property DataSet           : TDataSet        read FDataSet         write FDataset default nil;
    property Direction         : TDirection      read FDirection       write FDirection;
    property Options           : TOptions        read FOptions         write FOptions;
    property Serie             : TSerie          read FSerie           write FSerie;
    property GraphicOptions    : TGraphicOptions read FGraphicOptions  write FGraphicOptions;
    property Developer         : TDeveloper      read FDeveloper       write FDeveloper;
    property Proportional;
    property AutoSize;
    property Center;
    property Stretch;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Humberto',[TSalesGraphicWeb]);
end;

{ TDesenvolvedor }

constructor TDeveloper.Create;
begin
  FEmail := 'humbertoliveira@hotmail.com';
  FName := 'humberto sales';
  FTelegram := '@HumbertoSales';
  FTelegramGroup := 'https://t.me/lazarusfreepascal1';
  FVersion := '1.0.1.1'
end;


{ TColorStyle }

constructor TColorStyle.Create;
begin
  FBackgroundColor := clYellow;
  FStyle           := SNone
end;

destructor TColorStyle.Destroy;
begin
  inherited Destroy;
end;

{ TDataSets }

constructor TDataSets.Create;
begin
  Active        := False;
  FTransparency := 0;
  FborderWidth  := 0;
  FborderColor  := clNone;
  FGraphicType  := bar;
  FColorStyle   := TColorStyle.create;
  FborderColor  := clBlack;
  FborderWidth  := 3;
end;

destructor TDataSets.Destroy;
begin
  inherited Destroy;
end;

{ TLineGraphic }

constructor TLineGraphic.Create;
begin
  FFill         := false;
  FborderDash_C := 3;
  FborderDash_E := 3;
  FpointRadius  := 7;
end;

destructor TLineGraphic.Destroy;
begin
  inherited Destroy;
end;


{ TGraphicOptions }

constructor TGraphicOptions.Create;
begin
  FDoughnutGraphic := TDoughnutGraphic.create;
  FBarGraphic      := TBarGraphic.create;
  FhorizontalBar   := ThorizontalBar.create;
  FLineGraphic     := TLineGraphic.create;
end;

destructor TGraphicOptions.Destroy;
begin
  FreeAndNil(FLineGraphic);
  FreeAndNil(FhorizontalBar);
  FreeAndNil(FBarGraphic);
  FreeAndNil(FDoughnutGraphic);
  inherited Destroy;
end;

{ TDoughnutGraphic }

constructor TDoughnutGraphic.Create;
begin
  active      := false;
  Title       := '';
  FontSize    := 25;
  SubTitle    := LTotal;
end;

destructor TDoughnutGraphic.Destroy;
begin
  inherited Destroy;
end;

{ TBarGraphic }

constructor TBarGraphics.Create;
begin
  FroundedBars := False;
end;

destructor TBarGraphics.Destroy;
begin
  inherited Destroy;
end;

{ TScaleLabel }

constructor TScaleLabel.Create;
begin
  Fdisplay     := false;
  FlabelString := '';
end;

destructor TScaleLabel.Destroy;
begin
  inherited Destroy;
end;

{ OutLabelFonts }

constructor TOutLabelFonts.Create;
begin
  FResizable := true;
  FminSize   := 12;
  FmaxSize   := 18;
end;

{ TOutLabels }

constructor TOutLabels.Create;
begin
  FDisplay   := False;
  FText     := '%l %p';
  FColor    := clWhite;
  FStretch  := 35;
  FFont     := TOutLabelFonts.create;
end;

destructor TOutLabels.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

{ TSerie }

procedure TSerie.SetTransparency(AValue: byte);
begin
  if FTransparency=AValue then Exit;
  if AValue in [0..10] then
      FTransparency:=AValue
  else
     raise EGraphicException.CreateFmt('%s' + #13 + '%s', [ClassName,ETransparencyError]);
end;

constructor TSerie.Create;
begin
  Active        := False;
  FTransparency := 0;
  FborderWidth  := 0;
  FborderColor  := clNone;
end;

destructor TSerie.Destroy;
begin
  inherited Destroy;
end;

{ TTicks }

constructor TTicks.Create;
begin
  Fmin      := 0;
  Fmax      := 0;
  FstepSize := 0;
end;

destructor TTicks.Destroy;
begin
  inherited Destroy;
end;

{ TScales }

constructor TScales.Create;
begin
  FxAxes  := TAxis.Create;
  FyAxes  := TAxis.Create;
end;

destructor TScales.Destroy;
begin
  FreeAndNil(FxAxes);
  FreeAndNil(FyAxes);
  inherited Destroy;
end;


{ TAxis }


constructor TAxis.Create;
begin
  Fticks     := TTicks.create;
  FScalelabel:= TScalelabel.create;
end;

destructor TAxis.Destroy;
begin
  FreeAndNil(FScalelabel);
  FreeAndNil(Fticks);
  inherited Destroy;
end;

{ TDataLabels }

constructor TDataLabels.Create;
begin
  FDisplay:= false;
  FColor  := clNone;
  Falign  := center;
end;


{ TPlugins }

constructor TPlugins.Create;
begin
  FOutLabels   := TOutLabels.create;
  FDataLabels  := TDataLabels.create;
end;

destructor TPlugins.Destroy;
begin
  FreeAndNil(FDataLabels);
  FreeAndNil(FOutLabels);
  inherited Destroy;
end;


{ TTitle }

constructor TTitle.create;
begin
  Ffontsize := 0;
  Ffontcolor:= clBlack;
  Fposition := top;
  FDisplay  := True
end;

destructor TTitle.Destroy;
begin
  inherited Destroy;
end;

{ TOptions }

constructor TOptions.Create;
begin
  FTitle  := TTitle.create;
  FLegend := TLegend.create;
  FScale  := TScales.create;
  FPlugins:= TPlugins.create;
end;

destructor TOptions.Destroy;
begin
  FreeAndNil(FPlugins);
  FreeAndNil(FScale);
  FreeAndNil(FLegend);
  FreeAndNil(FTitle);
  inherited Destroy;
end;

{ TLegend }

constructor TLegend.Create;
begin
   FVisible  := true;
   Falign    := grStart;
   Fposition := LpLeft;
end;

destructor TLegend.Destroy;
begin
  inherited Destroy;
end;

{ TSalesGraphicWeb }

constructor TSalesGraphicWeb.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDirection       := drRow;
  FGraphicType     := bar;
  FGraphicWidth    := 480;
  FGraphicHeight   := 320;
  FBackGroundColor := clNone;
  Width            := 600;
  Height           := 380;
  center           := true;
  Proportional     := true;
  FOptions         := TOptions.Create;
  FPlugins         := TPlugins.create;
  FSerie           := TSerie.Create;
  FGraphicOptions  := TGraphicOptions.create;
  FDeveloper       := TDeveloper.Create;
end;

destructor TSalesGraphicWeb.Destroy;
begin
  FreeAndNil(FDeveloper);
  FreeAndNil(FGraphicOptions);
  FreeAndNil(FSerie);
  FreeAndNil(FPlugins);
  FreeAndNil(FOptions);
  inherited Destroy;
end;

function TSalesGraphicWeb.ColorToHex(FColor : TColor) : String;
var
  R, G, B: Byte;
begin
  RedGreenBlue(FColor, R, G, B);
  result:= Format('#%.2x%.2x%.2x', [R, G, B]);
end;

function TSalesGraphicWeb.ColorToRGBA(FColor : TColor; FTransparency : byte) : String;
var
  R, G, B: Byte;
begin
  RedGreenBlue(FColor, B, G, R);
  if FTransparency = 0 then
     result:= '"rgba(' +Format('%s, %s, %s, .%s', [R.tostring, G.tostring, B.tostring, '1']) + ')"'
  else
     result:= '"rgba(' +Format('%s, %s, %s, .%s', [R.tostring, G.tostring, B.tostring, FTransparency.tostring]) + ')"';
end;

procedure TSalesGraphicWeb.Show;
begin
  if (FDataSet = Nil) or (FDataSet.IsEmpty) then
     SendError(EGraphicCreateError);
  SendLink( CreateLink(Dataset,FDirection, GetEnumName(TypeInfo(TGraphicType),integer(FGraphicType))   ) );
end;

function TSalesGraphicWeb.removeAspas(AJson : String ) : String;
begin
    Result := ReplaceStr(AJson,'"type"','type');
    Result := ReplaceStr(Result,'"data"','data');
    Result := ReplaceStr(Result,'"labels"','labels');
    Result := ReplaceStr(Result,'"datasets"','datasets');
    Result := ReplaceStr(Result,'"label"','label');
    Result := ReplaceStr(Result,'"options"','options');
    Result := ReplaceStr(Result,'"title"','title');
    Result := ReplaceStr(Result,'"text"','text');
    Result := ReplaceStr(Result,'"display"','display');
    Result := ReplaceStr(Result,'"backgroundColor"','backgroundColor');
    Result := ReplaceStr(Result,'"legend"','legend');
    Result := ReplaceStr(Result,'"position"','position');
    Result := ReplaceStr(Result,'"align"','align');
    Result := ReplaceStr(Result,'"borderWidth"','borderWidth');
    Result := ReplaceStr(Result,'"borderColor"','borderColor');
    Result := ReplaceStr(Result,'"scales"','scales');
    Result := ReplaceStr(Result,'"yAxes"','yAxes');
    Result := ReplaceStr(Result,'"xAxes"','xAxes');
    Result := ReplaceStr(Result,'"labelString"','labelString');
    Result := ReplaceStr(Result,'"fontColor"','fontColor');
    Result := ReplaceStr(Result,'"fontSize"','fontSize');
    Result := ReplaceStr(Result,'"size"','size');
    Result := ReplaceStr(Result,'"fontStyle"','fontStyle');
    Result := ReplaceStr(Result,'"font"','font');
    Result := ReplaceStr(Result,'"plugins"','plugins');
    Result := ReplaceStr(Result,'"datalabels"','datalabels');
    Result := ReplaceStr(Result,'"roundedBars"','roundedBars');
    Result := ReplaceStr(Result,'"scaleLabel"','scaleLabel');
    Result := ReplaceStr(Result,'"ticks"','ticks');
    Result := ReplaceStr(Result,'"stretch"','stretch');
    Result := ReplaceStr(Result,'"min"','min');
    Result := ReplaceStr(Result,'"max"','max');
    Result := ReplaceStr(Result,'"stepSize"','stepSize');
    Result := ReplaceStr(Result,'"color"','color');
    Result := ReplaceStr(Result,'"outlabels"','outlabels');
    Result := ReplaceStr(Result,'"doughnutlabel"','doughnutlabel');
    Result := ReplaceStr(Result,'"fill"','fill');
    Result := ReplaceStr(Result,'"borderDash"','borderDash');
    Result := ReplaceStr(Result,'"pointRadius"','pointRadius');
    Result := ReplaceStr(Result,'"resizable"','resizable');
    Result := ReplaceStr(Result,'"minSize"', 'minSize');
    Result := ReplaceStr(Result,'"maxSize"', 'maxSize');
    Result := ReplaceStr(Result,'\"','');
end;

function TSalesGraphicWeb.CreateLink(DataSet: TDataSet; LineCol: TDirection;
  FGraphic: string): String;
var
  JMaster : TJsonNode;
  i, j: Integer;
  config , s: String;
  ASerie : byte;
  ASoma   : Double;
begin
  ASerie := 0;
  ASoma  := 0;
  JMaster := TjsonNode.create;
  With JMaster do
    try
      add('type', FGraphic);
      with add('data',nkObject) do
      begin
          case Direction of
          drCol :
                   begin
                   with add('labels',nkArray) do
                        with dataset do
                          begin
                            first;
                            while not eof do
                            begin
                               add('',dataset.fields[0].asstring);
                               next;
                            end;

                          end;
                   with add('datasets',nkArray) do
                   begin
                            with dataset do
                            begin
                                 DisableControls;
                                 for i := 1 to fieldcount -1 do
                                    begin
                                       with add('',nkObject) do
                                       begin
                                          if FGraphicType = line then
                                             begin
                                                add('fill',FGraphicOptions.LineGraphic.fill);
                                                with add('borderDash',nkArray) do
                                                   begin
                                                      add('borderDash',FGraphicOptions.LineGraphic.borderDash_C);
                                                      add('borderDash',FGraphicOptions.LineGraphic.borderDash_E);
                                                   end;
                                                add('pointRadius',FGraphicOptions.LineGraphic.pointRadius);
                                             end;
                                         add('label',fields[i].displayname);
                                         if FSerie.boderWidth <> 0 then
                                           add('borderWidth',FSerie.boderWidth);
                                         if FSerie.borderColor <> clNone then
                                           add('borderColor',ColorToHex( FSerie.borderColor ) );
                                         if FSerie.Style <> SNone then
                                           begin
                                              first;
                                              if FSerie.Active then
                                              with add('backgroundColor',nkArray) do
                                              while not eof do
                                              begin
                                                  Case FSerie.Style of
                                                  SCreative     : add('backgroundColor', ColorToRGBA( Creative[Aserie], FSerie.Transparency) );
                                                  SContinental  : add('backgroundColor', ColorToRGBA( Continental[Aserie], FSerie.Transparency) );
                                                  SDeezer       : add('backgroundColor', ColorToRGBA( Deezer[Aserie], FSerie.Transparency) );
                                                  SDelectable   : add('backgroundColor', ColorToRGBA( Delectable[Aserie], FSerie.Transparency) );
                                                  SDell         : add('backgroundColor', ColorToRGBA( Dell[Aserie], FSerie.Transparency) );
                                                  SDindr        : add('backgroundColor', ColorToRGBA( Dindr[Aserie], FSerie.Transparency) );
                                                  end;
                                                  Aserie += 1;
                                                  next;
                                              end;
                                           end;

                                         first;
                                         with Add('data',nkArray) do
                                         While not eof do
                                         begin
                                            add('',ReplaceStr(fields[i].asstring,',','.'));
                                            ASoma += fields[i].AsFloat;
                                            next;
                                         end;

                                       end;
                                    end;
                                 FGraphicOptions.DoughnutGraphic.Title := ASoma.ToString;
                                 EnableControls;
                            end;
                   end;
                   end; //drcol;

          drRow    :
                   begin
                   with add('labels',nkArray) do
                        for i := 1 to dataset.FieldCount -1 do
                            add('',dataset.fields[i].DisplayName);
                   with add('datasets',nkArray) do
                   begin
                         with dataset do
                         begin
                            DisableControls;
                            first;
                            while not eof do
                            begin
                               with add('',nkObject) do
                               begin
                                  if FGraphicType = line then
                                  begin
                                     FSerie.borderColor:= clNone;
                                     add('fill',FGraphicOptions.LineGraphic.fill);
                                     with add('borderDash',nkArray) do
                                        begin
                                           add('borderDash',FGraphicOptions.LineGraphic.borderDash_C);
                                           add('borderDash',FGraphicOptions.LineGraphic.borderDash_E);
                                        end;
                                     add('pointRadius',FGraphicOptions.LineGraphic.pointRadius);
                                  end;
                                  add('label',fields[0].asstring);
                                  if FSerie.boderWidth <> 0 then
                                    add('borderWidth',FSerie.boderWidth);
                                  if FSerie.borderColor <> clNone then
                                    add('borderColor',ColorToHex( FSerie.borderColor ) );
                                  if FSerie.Style <> SNone then
                                  begin
                                     if FSerie.Active then
                                     with add('backgroundColor',nkArray) do
                                       for i := 1 to FieldCount -1 do
                                         Case FSerie.Style of
                                         SCreative     : add('backgroundColor', ColorToRGBA( Creative[Aserie], FSerie.Transparency) );
                                         SContinental  : add('backgroundColor', ColorToRGBA( Continental[Aserie], FSerie.Transparency) );
                                         SDeezer       : add('backgroundColor', ColorToRGBA( Deezer[Aserie], FSerie.Transparency) );
                                         SDelectable   : add('backgroundColor', ColorToRGBA( Delectable[Aserie], FSerie.Transparency) );
                                         SDell         : add('backgroundColor', ColorToRGBA( Dell[Aserie], FSerie.Transparency) );
                                         SDindr        : add('backgroundColor', ColorToRGBA( Dindr[Aserie], FSerie.Transparency) );
                                         end;
                                         Aserie += 1;
                                  end;
                                  with Add('data',nkArray) do
                                      for i := 1 to fieldcount -1 do
                                         begin
                                              add('',ReplaceStr(fields[i].asstring,',','.'));
                                              ASoma += fields[i].asfloat;
                                         end;
                                  FGraphicOptions.DoughnutGraphic.Title := ASoma.ToString;
                               end;
                               next;
                            end;
                            EnableControls;
                         end;
                     end;
                   end; //drrow;
          end; //end case
      end;
      with add('options',nkObject) do
      begin
        with add('legend', nkobject) do
        begin
          config := GetEnumName(TypeInfo(TGrPosition),integer(FOptions.Legend.align ));
          system.delete(config,1,2);
          add('align',Lowercase(config));
          add('display',FOptions.Legend.Visible);
          config := GetEnumName(TypeInfo(TLegendPosition),integer(FOptions.Legend.position));
          system.delete(config,1,2);
          add('position',Lowercase(config));
        end;
        if FOptions.Title.display then
        with add('title',nkObject) do
        begin
          add('display',FOptions.Title.display);
          add('fontColor',ColorToHex(FOptions.Title.fontcolor));
          add('fontSize',FOptions.Title.fontsize);
          config := GetEnumName(TypeInfo(TGrFontStyle),integer(FOptions.Title.fontstyle));
          add('fontStyle',config);
          add('text',FOptions.Title.text);
        end;
        with add('plugins',nkObject) do
        begin
           if FOptions.Plugins.OutLabels.Display then
           begin
              with add('outlabels',nkObject) do
              begin
                add('display',FOptions.Plugins.OutLabels.Display);
                add('text',FOptions.Plugins.OutLabels.text);
                add('color',ColorToHex( FOptions.Plugins.OutLabels.Color ) );
                add('stretch',FOptions.Plugins.OutLabels.stretch);
                with add('font',nkObject) do
                begin
                   add('resizable',FOptions.Plugins.OutLabels.Font.Resizable);
                   add('minSize',FOptions.Plugins.OutLabels.Font.minSize);
                   add('maxSize',FOptions.Plugins.OutLabels.Font.maxSize);
                end;
              end;
           end;
           if Options.Plugins.DataLabels.Display then {nao ha relacoes com o grafico ... so para criar ou nao json}
           With add('datalabels',nkObject) do
           begin
              config := GetEnumName(TypeInfo(TGrAlign ),integer(FOptions.Plugins.DataLabels.Align));
              add('align',config);
              if FOptions.Plugins.DataLabels.Color <> clNone then
              add('color', ColorToHex(FOptions.Plugins.FDataLabels.Color) );
           end;
           if (GraphicType = bar) and (GraphicOptions.BarGraphic.roundedBars) then
              add('roundedBars',GraphicOptions.BarGraphic.roundedBars);
           if (GraphicType = horizontalBar) and (GraphicOptions.HorizontalBar.roundedBars) then
              add('roundedBars',GraphicOptions.HorizontalBar.roundedBars);
           if GraphicType = doughnut then
                if GraphicOptions.DoughnutGraphic.active then
                   with Jmaster.Find('options').Find('plugins').add('doughnutlabel',nkObject) do
                   begin
                      with add('labels',nkArray) do
                      with add('labels',nkObject) do
                      begin
                      add('text',FGraphicOptions.DoughnutGraphic.Title);
                      with add('font',nkObject) do
                        begin
                           add('size',FGraphicOptions.DoughnutGraphic.FontSize);
                        end;
                      with Jmaster.Find('options').Find('plugins').find('doughnutlabel').find('labels').add('',nkObject) do
                          begin
                           add('text',FGraphicOptions.DoughnutGraphic.SubTitle);
                          end;
                      end;
                   end;
        end;
        with Jmaster.Find('options').add('scales',nkObject) do
        begin
            if not (FGraphicType in [radar,pie,doughnut,polarArea,radialGauge,progressbar]) then
            With add('yAxes',nkArray) do
            begin
                With add('',nkObject) do
                begin
                   if FOptions.Scale.yAxes.ScaleLabel.display then
                   With add('scaleLabel',nkObject) do
                      begin
                         add('display', FOptions.Scale.yAxes.ScaleLabel.display);
                         add('labelString', FOptions.Scale.yAxes.ScaleLabel.labelString);
                      end;
                   With add('ticks',nkObject) do
                      begin
                         add('min',FOptions.Scale.yAxes.Ticks.min);
                         if FOptions.Scale.yAxes.Ticks.max > 0 then
                         add('max',FOptions.Scale.yAxes.Ticks.max);
                         if FOptions.Scale.yAxes.Ticks.stepSize > 0 then
                         add('stepSize',FOptions.Scale.yAxes.Ticks.stepSize);
                      end;
                end;
            end;
            if not (FGraphicType in [radar,pie,doughnut,polarArea,radialGauge,progressbar]) then
            With add('xAxes',nkArray) do
                begin
                   With add('',nkObject) do
                   begin
                      if FOptions.Scale.xAxes.ScaleLabel.display then
                      With add('scaleLabel',nkObject) do
                         begin
                            add('display', FOptions.Scale.xAxes.ScaleLabel.display);
                            add('labelString', FOptions.Scale.xAxes.ScaleLabel.labelString);
                         end;
                      With add('ticks',nkObject) do
                         begin
                            add('min',FOptions.Scale.xAxes.Ticks.min);
                            if FOptions.Scale.xAxes.Ticks.max > 0 then
                            add('max',FOptions.Scale.xAxes.Ticks.max);
                            if FOptions.Scale.xAxes.Ticks.stepSize > 0 then
                            add('stepSize',FOptions.Scale.xAxes.Ticks.stepSize);
                         end;
                   end;
                end;
        end; //scale
      end;  //options
    Finally
    result := removeAspas( JMaster.AsJson );
    free;
    end;
end;


function TSalesGraphicWeb.SendLink(ALink: String): String;
var
  m: TMemoryStream;
  AFile,_Link : String;
begin
  _Link := Link;
  AFile := FloatTostr(Time);
  AFile := ReplaceStr(ReplaceStr(AFile,'.',''),':','');
  With Tfphttpclient.create(nil) do
    try
       m := TMemoryStream.Create;
       AllowRedirect:= true;
       {***background***}
       case FBackGroundColor of
         clNone : _Link := StringReplace(_Link,'%s','bkg=transparent',[]);
       else
         _Link := StringReplace(link,'%s','bkg=' + EncodeURLElement( ColorToHex(FBackGroundColor) ),[]);
       end;
       {***largura***}
       _Link := StringReplace(_Link,'%s','w=' + FGraphicWidth.toString ,[]);
       {***altura***}
       _Link := StringReplace(_Link,'%s','h=' + FGraphicHeight.toString ,[]);
       _Link := StringReplace(_Link,'%s','',[rfReplaceAll]);
       //envia
       try
          IOTimeout:= 20000;
          Get( _Link + EncodeURLElement(ALink),m );
       except
         Case ResponseStatusCode of
            500 :  SendError(EApiPasswordError);
            404 :  SendError(EApiServerOff);
            else   SendError(EApiCommunicationError);
         end;
       end;
    finally
      m.SaveToFile(AFile);
      Stretch:= true;
      Picture.LoadFromFile(AFile);
      freeandnil(m);
      DeleteFile(AFile);
      free;
    end;
end;

procedure TSalesGraphicWeb.SetBackGroundColor(AValue: TColor);
begin
  if FBackGroundColor=AValue then Exit;
  FBackGroundColor:=AValue;
end;

procedure TSalesGraphicWeb.SetGraphicHeight(AValue: integer);
begin
  if FGraphicHeight=AValue then Exit;
  FGraphicHeight:=AValue;
end;

procedure TSalesGraphicWeb.SetGraphicType(AValue: TGraphicType);
begin
  if FGraphicType=AValue then Exit;
  FGraphicType:=AValue;
end;

procedure TSalesGraphicWeb.SetGraphicWidth(AValue: integer);
begin
  if FGraphicWidth=AValue then Exit;
  FGraphicWidth:=AValue;
end;

procedure TSalesGraphicWeb.SendError(FTexto: String);
var
  Style : TTextStyle;
begin
  Style.Alignment:= taCenter;
  Style.Layout   := tlCenter;
  Style.Wordbreak:= true;
  with Self.Canvas do
    begin
      FillRect(ClientRect);
      Font.Color := $00FF9800;
      Font.Size  := 25;
      Font.Style := Font.Style + [fsBold];
      TextRect(ClientRect,0,0,FTexto,Style);
    end;

end;

procedure TSalesGraphicWeb.Notification(AComponent: TComponent; Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
   if (AComponent = FDataSet) and (Operation = opRemove) then
      FDataSet := Nil;
end;


initialization
{$i salesgraphicweb.lrs}

end.

{Next}
{grafico de combinação}
{type:"bar",data:{labels:["Humberto","Gilberto","Marcelo"],
datasets:[{type: "bar",label:"jan",data:["130","155","120"]},{type: "line",label:"Fev",data:["190","145","225"]},{label:"jan",data:["230","125","214"]}],
},options:{plugins:{},scales:{yAxes:[{ticks:{min:0}}]}}}
