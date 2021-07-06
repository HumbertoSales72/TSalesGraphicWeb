unit Unit1;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
   BufDataset, DB, SalesGraphicWeb;


type

  { TForm1 }
  TForm1 = class(TForm)
    BufDataset1: TBufDataset;
    BufDataset2: TBufDataset;
    Button4: TButton;
    Button5: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    SalesGraphicWeb1: TSalesGraphicWeb;
    SalesGraphicWeb2: TSalesGraphicWeb;
    SalesGraphicWeb3: TSalesGraphicWeb;
    SalesGraphicWeb4: TSalesGraphicWeb;
    SalesGraphicWeb5: TSalesGraphicWeb;
    SalesGraphicWeb6: TSalesGraphicWeb;
    SalesGraphicWeb7: TSalesGraphicWeb;
    SalesGraphicWeb8: TSalesGraphicWeb;
    SalesGraphicWeb9: TSalesGraphicWeb;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure copyBuf(Origem, Destino: TBufDataset);
  public
    const
    Link =   'http://quickchart.io/chart?%s%s%s&c=';
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.Button4Click(Sender: TObject);
begin
  SalesGraphicWeb1.Show;
  SalesGraphicWeb3.Show;
  SalesGraphicWeb5.Show;
  SalesGraphicWeb6.Show;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  SalesGraphicWeb2.show;
  SalesGraphicWeb4.show;
  SalesGraphicWeb7.show;
  SalesGraphicWeb8.show;
end;

procedure TForm1.copyBuf(Origem,Destino : TBufDataset);
var
  i: Integer;
begin
   origem.first;
   while not origem.eof do
      begin
         destino.insert;
         for i := 0 to Destino.Fields.Count -1 do
           destino.Fields[i].value := origem.Fields[i].value;
         destino.post;
         origem.next;
      end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormatSettings.DateSeparator:='/';
  FormatSettings.LongDateFormat:='dd/mm/yyyy';

  DBGrid1.FocusColor := clyellow;
  DBGrid1.SelectedColor:= clGreen;
  DBGrid2.FocusColor := clBlue;
  DBGrid2.SelectedColor:= $CD7921;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  with BufDataset1, BufDataset1.FieldDefs do
      begin
         add('Nome',ftString,20);
         add('jan',ftFloat);
         add('fev',ftFloat);
         add('mar',ftFloat);
         CreateDataset;
         BufDataset1.Insert;
         Fieldbyname('Nome').asstring := 'Humberto';
         Fieldbyname('jan').asfloat := 80;
         Fieldbyname('fev').asfloat := 122;
         Fieldbyname('mar').asfloat := 113;
         post;
         BufDataset1.Insert;
         Fieldbyname('Nome').asstring :=  'Gilberto';
         Fieldbyname('jan').asfloat :=  145;
         Fieldbyname('Fev').asfloat := 130;
         Fieldbyname('mar').asfloat := 155;
         post;
         BufDataset1.Insert;
         Fieldbyname('Nome').asstring := 'Marcelo';
         Fieldbyname('jan').asfloat := 160;
         Fieldbyname('Fev').asfloat := 144;
         Fieldbyname('mar').asfloat := 138;
         post;
      end;

  BufDataset2.FieldDefs.Assign(BufDataset1.FieldDefs);
  BufDataset2.FieldDefs.delete(3);
  BufDataset2.FieldDefs.delete(2);
  BufDataset2.CreateDataset;
  BufDataset2.open;
  copybuf(BufdataSet1,BufDataset2);
end;

initialization
SetHeapTraceOutput('error.txt');

end.

