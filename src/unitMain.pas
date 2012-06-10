//------------------------------------------------------------------------------
// Name der Unit: unitMain
//
// Projekt: bva.dpr
// In diesem Praktikum sollen Algorithmen zur Polarabtastung implementiert
// und ihre Anwendnugsmöglichkeiten, aber auch ihre Grenzen experimentell
// untersucht werden.
//
//
// Mainunit des Projekts
//
// Verwendete Units:
// -----------------------------
//  unitTypes : Unit, in der benötigte Dateitypen definiert sind.
//  unitImage : Unit, die alle benötigten Bildoperationen bereitstellt
//
// Autoren: Alexander Bertram (2616)
//          Rüdiger Klante    (2381)
//
// erstellt am: 01.06.2006
//
// letzte Änderung: 22.06.2006
//
//------------------------------------------------------------------------------
unit unitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, Menus, ExtCtrls, ToolWin, ComCtrls, StdCtrls, TeEngine,
  Series, TeeProcs, Chart;

type
  TFormBVA = class(TForm)
    mmMenu: TMainMenu;
    miFile: TMenuItem;
    miOpen1: TMenuItem;
    opdOpenImage: TOpenPictureDialog;
    N1: TMenuItem;
    miClose: TMenuItem;
    lblCoG: TLabel;
    btnCompareObjs: TButton;
    lblEqual: TLabel;
    miOpen2: TMenuItem;
    lblCog2: TLabel;
    lblRotate: TLabel;
    lblXdiff: TLabel;
    lblYdiff: TLabel;
    miExtended: TMenuItem;
    grpboxExtended1: TGroupBox;
    btnGray1: TButton;
    btnMedian1: TButton;
    btnBinary1: TButton;
    btnCoG1: TButton;
    btnHisto1: TButton;
    grpBoxPic1: TGroupBox;
    imgImage: TImage;
    grpBoxPic2: TGroupBox;
    imgImage2: TImage;
    grpboxExtended2: TGroupBox;
    btnGray2: TButton;
    btnMedian2: TButton;
    btnBinary2: TButton;
    btnCoG2: TButton;
    btnHisto2: TButton;
    ChartHisto1: TChart;
    srsGrayLevel: TBarSeries;
    ChartPolar1: TChart;
    ChartPolar2: TChart;
    ChartHisto2: TChart;
    srsGrayLevel2: TBarSeries;
    srsPolar1: TFastLineSeries;
    btnKontur1: TButton;
    btnKontur2: TButton;
    Optionen1: TMenuItem;
    Vergleichsmethode1: TMenuItem;
    miPolarcoding: TMenuItem;
    miPolarMitKontur: TMenuItem;
    srsPolar2: TFastLineSeries;
    procedure miOpen1Click(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure btnGray1Click(Sender: TObject);
    procedure btnHisto1Click(Sender: TObject);
    procedure btnMedian1Click(Sender: TObject);
    procedure btnCoG1Click(Sender: TObject);
    procedure btnBinary1Click(Sender: TObject);
    procedure btnCompareObjsClick(Sender: TObject);
    procedure miOpen2Click(Sender: TObject);
    procedure miExtendedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGray2Click(Sender: TObject);
    procedure btnBinary2Click(Sender: TObject);
    procedure btnCoG2Click(Sender: TObject);
    procedure btnMedian2Click(Sender: TObject);
    procedure btnHisto2Click(Sender: TObject);
    procedure btnKontur1Click(Sender: TObject);
    procedure btnKontur2Click(Sender: TObject);
    procedure miPolarcodingClick(Sender: TObject);
    procedure miPolarMitKonturClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormBVA: TFormBVA;

implementation

{$R *.dfm}

uses
  unitImage, unitTypes;

//------------------------------------------------------------------------------
// miOpen1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von miOpen1 (Öffnen des 1. Bildes)
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: saveForReload
//------------------------------------------------------------------------------
procedure TFormBVA.miOpen1Click(Sender: TObject);
begin
  if opdOpenImage.Execute then
  begin
    imgImage.Picture.LoadFromFile(opdOpenImage.FileName);
    imgimage.Picture.Bitmap.PixelFormat := pf24bit;
    saveForReload(imgImage.Picture.Bitmap,1);  // Sichern des Originalbildes
    srsPolar1.Clear;
    srsGrayLevel.Clear;
    // Labels setzen
    lblEqual.Caption := '';
    lblCoG.Caption := '';
    lblCog2.Caption := '';
    lblRotate.Caption := '';
    lblXdiff.Caption := '';
    lblYdiff.Caption := '';
    // Buttons aktivieren/deaktivieren
    btnGray1.Enabled := true;
    btnMedian1.Enabled := false;
    btnBinary1.Enabled := false;
    btnCoG1.Enabled := false;
    btnHisto1.Enabled := false;
    ChartPolar1.Visible := false;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// miCloseClick
//------------------------------------------------------------------------------
// Onclick-Prozedur von miCloseClick -> Schliessen des Programms
//------------------------------------------------------------------------------
procedure TFormBVA.miCloseClick(Sender: TObject);
begin
  Close;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnGray1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnGray1 -> Bild 1 in Grauwerte umwandeln
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateGrayLevelImage
//------------------------------------------------------------------------------
procedure TFormBVA.btnGray1Click(Sender: TObject);
var
  Bitmap,                     // Bitmap, auf der gearbeitet wird
  dummyBMP: Graphics.TBitmap; // dummy Bitmap zum Aufruf der reload-Prozedur
begin
  Bitmap := graphics.TBitmap.Create;
  dummyBMP := graphics.TBitmap.Create;
  reloadImage(Bitmap,dummyBMP);
  CreateGrayLevelImage(Bitmap);   // Grauwertumwandlung
  imgImage.Picture.Assign(Bitmap);
  imgImage.Refresh;
  // Buttons aktivieren/deaktivieren
  btnGray1.Enabled := false;
  btnMedian1.Enabled := true;
  btnBinary1.Enabled := true;
  btnHisto1.Enabled := true;
  Bitmap.Free;
  dummyBMP.Free;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnHisto1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnHisto1 -> Histogramm für Bild 1 erstellen
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateGrayLevelArray
//------------------------------------------------------------------------------
procedure TFormBVA.btnHisto1Click(Sender: TObject);
var
  i: byte;   // Laufvariable
  GrayLevelArray: TGrayLevelArray; // Histogramm
  BitMap: TBitmap;  // Bitmap, auf der gearbeitet wird
begin
  BitMap := imgImage.Picture.Bitmap;
  GrayLevelArray := GetGrayLevelArray(BitMap);  // Histogramm erstellen
  srsGrayLevel.Clear;
  for i := low(byte) to high(byte) do   // Histogramm visualisieren
    srsGrayLevel.AddXY(i, GrayLevelArray[i]);

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnMedian1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnMedian1 -> Medianfilter auf Bild 1 anwenden
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: MedianFilter
//------------------------------------------------------------------------------
procedure TFormBVA.btnMedian1Click(Sender: TObject);
var
  BitMap: TBitmap; // Bitmap, auf der gearbeitet wird
begin
  Screen.Cursor := crHourGlass;
  BitMap := imgImage.Picture.Bitmap;
  //Median-Filter anwenden
  MedianFilter(BitMap, 5);
  btnMedian1.Enabled := false;
  Screen.Cursor := crArrow;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnCoG1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnCoG1 -> Flächenschwerpunkt von Objekt in Bild 1
// ermitteln
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: getCoG
//------------------------------------------------------------------------------
procedure TFormBVA.btnCoG1Click(Sender: TObject);
var
  BitMap: TBitmap;  // Bitmap, auf der gearbeitet wird
  CoG : TCoordinate; // Schwerpunkt
begin
  BitMap := imgImage.Picture.Bitmap;

  //Schwerpunkt ermitteln
  CoG := getCoG(Bitmap);

  // Anzeige des ermittelten Punktes
  lblCoG.Caption := 'Schwerpunkt: ' + IntToStr(CoG.x) + ',' + IntToStr(CoG.y);

  // Fadenkreuz zeichnen
  Bitmap.Canvas.Pen.Color := clRed;
  Bitmap.Canvas.Pen.Width := 5;
  Bitmap.Canvas.MoveTo(CoG.x+20,CoG.Y);
  Bitmap.Canvas.LineTo(CoG.x-20,CoG.y);
  Bitmap.Canvas.Pen.Color := clRed;
  Bitmap.Canvas.MoveTo(CoG.x,CoG.Y+20);
  Bitmap.Canvas.LineTo(CoG.x,CoG.y-20);
  // Button deaktivieren
  btnCoG1.Enabled := false;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnBinary1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnBinary1 -> Bild 1 in Binärbild umwandeln
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateBinary
//------------------------------------------------------------------------------
procedure TFormBVA.btnBinary1Click(Sender: TObject);
var
  BitMap: TBitmap;  // Bitmap, auf der gearbeitet wird
begin
  BitMap := imgImage.Picture.Bitmap;
  CreateBinary(BitMap);
  // Buttons aktivieren/deaktivieren
  btnMedian1.Enabled := false;
  btnBinary1.Enabled := false;
  btnCoG1.Enabled := true;
  btnHisto1.Enabled := false;
  btnKontur1.Enabled := true;
end;
//------------------------------------------------------------------------------

 
//------------------------------------------------------------------------------
// btnCompareObjsClick
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnCompareObjs -> vergleichen von Bild 1 und Bild 2
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateGrayLevelImage, MedianFilter, CreateBinary,
//                            getCoG, getPolarArray, getPolarArrayDirection,
//                            compareObjects
//------------------------------------------------------------------------------
procedure TFormBVA.btnCompareObjsClick(Sender: TObject);
var equal : boolean;  // Gleichheit der Objekte
    BMP1,BMP2 : Graphics.TBitmap;  // Bitmaps, auf denen gearbeitet wird
    CoG1,CoG2 : TCoordinate;  // Schwerpunkte
    Polar1,Polar2 : TPolarArray;  // Polararrays
    angleDiff,    // Winkeldifferenz
    j : double;  // double-Laufvariable zur Visualisierung des Polarcodings
    i : integer; // Laufvariable zur Visualisierung des Polarcodings
begin

  if    (not(imgimage.Picture.Graphic = nil)         // Existieren überhaupt
    and (not(imgimage2.Picture.Graphic = nil))) then // Bilder?
  begin
    BMP1 := Graphics.TBitmap.Create;
    BMP2 := Graphics.TBitmap.Create;

    reloadImage(BMP1,BMP2);  // Neuladen der gesichterten Bilder vor der
                             // Verarbeitung

    Screen.Cursor := crHourGlass;

    // Vorverarbeitung
    CreateGrayLevelImage(BMP1);  // Grauwertbilder erstellen
    CreateGrayLevelImage(BMP2);
    MedianFilter(BMP1,5);   // Medianfilter mit 5*5 Maske auf beide
    MedianFilter(BMP2,5);   // Bilder anwenden
    CreateBinary(BMP1);     // Binärbilder erstellen
    CreateBinary(BMP2);

    // Bestimmung des Schwerpunktes (zu Anzeigezwecken)
    CoG1 := getCoG(BMP1);
    CoG2 := getCoG(BMP2);

    // Anzeige des ermittelten Punktes
    lblCoG.Caption := 'Schwerpunkt: ' + IntToStr(CoG1.x) + ',' + IntToStr(CoG1.y);
    lblCoG2.Caption := 'Schwerpunkt: ' + IntToStr(CoG2.x) + ',' + IntToStr(CoG2.y);

    // Auswahl der Vergleichsmethode anhand des selektierten Menueintrags
    if miPolarcoding.Checked then
    begin
      Polar1 := getPolarArray(BMP1);   // Polarabtastung von Bild 1
      Polar2 := getPolarArray(BMP2);   // Polarabtastung von Bild 2
    end else
    if miPolarMitKontur.Checked then
    begin
        Polar1 := getPolarArrayDirection(BMP1);  // Polarabtastung von Bild 1
        Polar2 := getPolarArrayDirection(BMP2);  // Polarabtastung von Bild 2
    end;

    equal := compareObjects(Polar1,Polar2,angleDiff); // Objekte vergleichen

    // Polarabtastung Objekt 1 visualisieren
    j := 0;
    srsPolar1.Clear;
    for i := low(TAngleSteps) to high(TAngleSteps) do
    begin
      j := j+cAngleStepSize;
      srsPolar1.AddXY(j, Polar1[i]);
    end;

    // Polarabtastung Objekt 2 visualisieren
    j := 0;
    srsPolar2.Clear;
    for i := low(TAngleSteps) to high(TAngleSteps) do
    begin
      j := j+cAngleStepSize;
      srsPolar2.AddXY(j, Polar2[i]);
    end;

    // Schwerpunkt in Bild 1 einzeichnen
    with imgImage.Canvas do
    begin
      Pen.Color := clRed;
      Pen.Width := 5;
      MoveTo(CoG1.x+20,CoG1.Y);
      LineTo(CoG1.x-20,CoG1.y);
      MoveTo(CoG1.x,CoG1.Y+20);
      LineTo(CoG1.x,CoG1.y-20);
    end;

    // Schwerpunkt in Bild 2 einzeichnen
    with imgImage2.Canvas do
    begin
      Pen.Color := clRed;
      Pen.Width := 5;
      MoveTo(CoG2.x+20,CoG2.Y);
      LineTo(CoG2.x-20,CoG2.y);
      MoveTo(CoG2.x,CoG2.Y+20);
      LineTo(CoG2.x,CoG2.y-20);
    end;

    if equal then
    begin
    // Anzeige entsprechend anpassen
      lblEqual.Caption := 'Objekte identisch!';
      if angleDiff = 0 then
      lblRotate.Caption :=
        'Rotation: ' + '0,000' + '°'
      else lblRotate.Caption :=
        'Rotation: ' + FloatToStrf(360-angleDiff,ffFixed,3,3) + '°';
      lblXdiff.Caption := 'Verschiebung x: ' + intToStr(CoG2.x-CoG1.x);
      lblYdiff.Caption := 'Verschiebung y: ' + intToStr(CoG2.y-CoG1.y);
    end
    else
    begin
    // Anzeige entsprechend anpassen
      lblEqual.Caption := 'Objekte verschieden!';
      lblRotate.Caption := '';
      lblXdiff.Caption := '';
      lblYdiff.Caption := '';
    end;
    BMP1.free; // Garbage-Collecting ;)
    BMP2.free;
    Screen.Cursor := crArrow;
    ChartPolar1.Visible := true;
    ChartPolar2.Visible := true;
  end else showmessage('Nicht genug Bilder geladen!');
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// miOpen2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von miOpen2 (Öffnen des 2. Bildes)
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: saveForReload
//------------------------------------------------------------------------------
procedure TFormBVA.miOpen2Click(Sender: TObject);
begin
  if opdOpenImage.Execute then
  begin
    srsPolar2.Clear;
    srsGrayLevel.Clear;
    imgImage2.Picture.LoadFromFile(opdOpenImage.FileName);
    imgimage.Picture.Bitmap.PixelFormat := pf24bit;
    saveForReload(imgImage2.Picture.Bitmap,2);
    lblEqual.Caption := '';
    btnGray2.Enabled := true;
    btnMedian2.Enabled := false;
    btnBinary2.Enabled := false;
    btnCoG2.Enabled := false;
    btnHisto2.Enabled := false;
    ChartPolar2.Visible := false;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// miExtendedClick
//------------------------------------------------------------------------------
// Onclick-Prozedur von miExrended -> erweiterte Optionen togglen
//------------------------------------------------------------------------------
procedure TFormBVA.miExtendedClick(Sender: TObject);
begin
  // Aktivieren/deaktivieren der Sichtbarkeit der erweiterten Optionen
  miExtended.Checked := not miExtended.Checked;
  btnGray1.Visible := not btnGray1.Visible;
  btnMedian1.Visible := not btnMedian1.Visible;
  btnCoG1.Visible := not btnCoG1.Visible;
  btnBinary1.Visible := not btnBinary1.Visible;
  btnHisto1.Visible := not btnHisto1.Visible;
  grpboxExtended1.Visible := not grpboxExtended1.Visible;
  grpboxExtended2.Visible := not grpboxExtended2.Visible;
  ChartHisto1.Visible := not ChartHisto1.Visible;
  ChartHisto2.Visible := not ChartHisto2.Visible;
  btnGray2.Visible := not btnGray2.Visible;
  btnMedian2.Visible := not btnMedian2.Visible;
  btnCoG2.Visible := not btnCoG2.Visible;
  btnBinary2.Visible := not btnBinary2.Visible;
  btnHisto2.Visible := not btnHisto2.Visible;
  btnKontur1.Visible := not  btnKontur1.Visible;
  btnKontur2.Visible := not  btnKontur2.Visible;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// FormCreate
//------------------------------------------------------------------------------
// OnCreate Prozedur von FormBVA -> Initialisieren des Displays
//------------------------------------------------------------------------------
procedure TFormBVA.FormCreate(Sender: TObject);
begin
  ChartPolar1.Visible := false;
  ChartPolar2.Visible := false;
  // Buttons der erweiterten Optionen deaktivieren
  btnGray1.Enabled := false;
  btnMedian1.Enabled := false;
  btnBinary1.Enabled := false;
  btnCoG1.Enabled := false;
  btnHisto1.Enabled := false;
  btnGray2.Enabled := false;
  btnMedian2.Enabled := false;
  btnBinary2.Enabled := false;
  btnCoG2.Enabled := false;
  btnHisto2.Enabled := false;
  btnKontur1.Enabled := false;
  btnKontur2.Enabled := false;
  miExtended.Checked := false;

  // Sichtbarkeit der erweiterten Optionen deaktivieren
  btnGray1.Visible := false;
  btnMedian1.Visible := false;
  btnCoG1.Visible := false;
  btnBinary1.Visible := false;
  btnHisto1.Visible := false;
  grpboxExtended1.Visible := false;
  grpboxExtended2.Visible := false;
  ChartHisto1.Visible := false;
  ChartHisto2.Visible := false;
  btnGray2.Visible := false;
  btnMedian2.Visible := false;
  btnCoG2.Visible := false;
  btnBinary2.Visible := false;
  btnHisto2.Visible := false;
  btnKontur2.Visible := false;
  btnKontur1.Visible := false;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnGray2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnGray2 -> Bild 2 in Grauwerte umwandeln
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateGrayLevelImage
//------------------------------------------------------------------------------
procedure TFormBVA.btnGray2Click(Sender: TObject);
var
  Bitmap,                      // Bitmap, auf der gearbeitet wird
  dummyBMP: Graphics.TBitmap;  // dummy Bitmap zum Aufruf der reload-Prozedur
begin
  Bitmap := graphics.TBitmap.Create;
  dummyBMP := graphics.TBitmap.Create;
  reloadImage(Bitmap,dummyBMP);
  CreateGrayLevelImage(Bitmap);
  imgImage2.Picture.Assign(Bitmap);
  imgImage2.Refresh;
  btnGray2.Enabled := false;
  btnMedian2.Enabled := true;
  btnBinary2.Enabled := true;
  btnHisto2.Enabled := true;
  Bitmap.Free;
  dummyBMP.Free;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnBinary2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnBinary2 -> Bild 2 in Binärbild umwandeln
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateBinary
//------------------------------------------------------------------------------
procedure TFormBVA.btnBinary2Click(Sender: TObject);
var
  BitMap: TBitmap;    // Bitmap, auf der gearbeitet wird
begin
  BitMap := imgImage2.Picture.Bitmap;
  CreateGrayLevelImage(Bitmap);
  CreateBinary(BitMap);
  btnMedian2.Enabled := false;
  btnBinary2.Enabled := false;
  btnCoG2.Enabled := true;
  btnHisto2.Enabled := false;
  btnKontur2.Enabled := true;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnCoG2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnCoG2 -> Flächenschwerpunkt von Objekt in Bild 2
// ermitteln
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: getCoG
//------------------------------------------------------------------------------
procedure TFormBVA.btnCoG2Click(Sender: TObject);
var
  BitMap: TBitmap;    // Bitmap, auf der gearbeitet wird
  CoG : TCoordinate;   // Schwerpunkt
begin
  BitMap := imgImage2.Picture.Bitmap;

  //Schwerpunkt ermitteln
  CoG := getCoG(Bitmap);

  // Anzeige des ermittelten Punktes
  lblCoG2.Caption := 'Schwerpunkt: ' + IntToStr(CoG.x) + ',' + IntToStr(CoG.y);

  // Fadenkreuz zeichnen
  Bitmap.Canvas.Pen.Color := clRed;
  Bitmap.Canvas.Pen.Width := 5;
  Bitmap.Canvas.MoveTo(CoG.x+20,CoG.Y);
  Bitmap.Canvas.LineTo(CoG.x-20,CoG.y);
  Bitmap.Canvas.Pen.Color := clRed;
  Bitmap.Canvas.MoveTo(CoG.x,CoG.Y+20);
  Bitmap.Canvas.LineTo(CoG.x,CoG.y-20);
  btnCoG2.Enabled := false;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnMedian2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnMedian2 -> Medianfilter auf Bild 2 anwenden
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: MedianFilter
//------------------------------------------------------------------------------
procedure TFormBVA.btnMedian2Click(Sender: TObject);
var
  BitMap: TBitmap;   // Bitmap, auf der gearbeitet wird
begin
  Screen.Cursor := crHourGlass;
  BitMap := imgImage2.Picture.Bitmap;
  //Median-Filter anwenden
  MedianFilter(BitMap, 5);
  btnMedian2.Enabled := false;
  Screen.Cursor := crArrow;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnHisto2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnHisto2 -> Histogramm für Bild 2 erstellen
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: CreateGrayLevelArray
//------------------------------------------------------------------------------
procedure TFormBVA.btnHisto2Click(Sender: TObject);
var
  i: byte;   // Laufvariable
  GrayLevelArray: TGrayLevelArray;  // Histogramm
  BitMap: TBitmap;  // Bitmap, auf der gearbeitet wird
begin
  BitMap := imgImage2.Picture.Bitmap;
  GrayLevelArray := GetGrayLevelArray(BitMap); // Histogramm erstellen
  srsGrayLevel2.Clear;
  for i := low(byte) to high(byte) do         // Histogramm visualisieren
    srsGrayLevel2.AddXY(i, GrayLevelArray[i]);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnKontur1Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnKontur1 -> Kontur von Objekt in Bild 1 abtasten
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: walkTheLine
//------------------------------------------------------------------------------
procedure TFormBVA.btnKontur1Click(Sender: TObject);
var
  BitMap: TBitmap;  // Bitmap, auf der gearbeitet wird
  dirarr : TPolarArrayDynamic; // Ergebnis der Konturabtastung
  i : integer;  // Laufvariable
begin
  BitMap := imgImage.Picture.Bitmap;
  dirarr := walkTheLine(Bitmap);
  btnkontur1.Enabled := false;
  srsPolar1.Clear;
  for i := 0 to length(dirarr)-1 do
    srsPolar1.AddXY(i, dirarr[i]);

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// btnKontur2Click
//------------------------------------------------------------------------------
// Onclick-Prozedur von btnKontur2 -> Kontur von Objekt in Bild 2 abtasten
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: walkTheLine
//------------------------------------------------------------------------------
procedure TFormBVA.btnKontur2Click(Sender: TObject);
var
  BitMap: TBitmap; // Bitmap, auf der gearbeitet wird
  dirarr : TPolarArrayDynamic; // Ergebnis der Konturabtastung
  i  :integer;  // Laufvariable
begin
  BitMap := imgImage2.Picture.Bitmap;
  dirarr := walkTheLine(Bitmap);
  btnKontur2.Enabled := false;
    srsPolar2.Clear;
  for i := 0 to length(dirarr)-1 do
    srsPolar2.AddXY(i, dirarr[i]);


end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// miPolarcodingClick
//------------------------------------------------------------------------------
// Onclick-Prozedur von miPolarcoding -> Vergleichsmethode wird auf "simples"
//                                       Polarcoding gesetzt
//------------------------------------------------------------------------------
procedure TFormBVA.miPolarcodingClick(Sender: TObject);
begin
  if miPolarMitKontur.Checked then
  begin
    miPolarMitKontur.Checked := false;
    miPolarcoding.Checked := true;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// miPolarMitKonturClick
//------------------------------------------------------------------------------
// Onclick-Prozedur von miPolarMitKontur -> Vergleichsmethode wird auf
//                                       Polarcoding mit Berücksichtigung
//                                       von Durchbrüchen und der Richtungs-
//                                       abhängigkeit der Kontur gesetzt.
//------------------------------------------------------------------------------
procedure TFormBVA.miPolarMitKonturClick(Sender: TObject);
begin
  if miPolarcoding.Checked then
  begin
    miPolarMitKontur.Checked := true;
    miPolarcoding.Checked := false;
  end;
end;
//------------------------------------------------------------------------------

end.
