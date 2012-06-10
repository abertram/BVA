//------------------------------------------------------------------------------
// Name der Unit: unitImage.
//
// Projekt: bva.dpr
// In diesem Praktikum sollen Algorithmen zur Polarabtastung implementiert
// und ihre Anwendnugsmöglichkeiten, aber auch ihre Grenzen experimentell
// untersucht werden.
//
//
//
// Diese Unit enthaelt alle Bildoperationen.
//
// Schnittstelle :
// -----------------------------
// Prozedur zur Umwandlung eines Bildes in ein Grauwertbild
//  procedure CreateGrayLevelImage(var Bitmap: Graphics.TBitmap);
//
// Funktion zur Erstellung eines Histogramms aus Grauwertbildern 
//  function GetGrayLevelArray(Bitmap: Graphics.TBitmap): TGrayLevelArray; overload;
//
// Prozedur zur Median-Filterung eines Grauwertbildes
//  procedure MedianFilter(var Bitmap: Graphics.TBitmap;m : byte); overload;
//
// Prozedur zur Binärbilderstellung, Verfahren von "Otsu"
//  procedure CreateBinary(var Bitmap: Graphics.TBitmap);
//
// Funktion zur Bestimmung des Flächenschwerpunktes eines Objektes im Bild
//  function getCoG(Bitmap: Graphics.TBitmap) : TCoordinate;
//
// Prozedur zum Neuladen der gesicherten Bilder
//  procedure reloadImage(var Bitmap1: Graphics.TBitmap; var Bitmap2 : Graphics.TBitmap);
//
// Prozedur zum Speichern des Originalbildes zum späteren Neuladen
//  procedure saveForReload(Bitmap: Graphics.TBitmap; index : integer);
//
// Funktion zur Ermittlung eines das Objekt im Bild umschreibenden Rechtecks
//  function getRectAngle(Bitmap : Graphics.TBitmap) : TRectArray;
//
// Funktion zur Abtastung eines Objekts an seiner Kontur entlang
//  function walkTheLine(var Bitmap : Graphics.TBitmap) : TPolarArrayDynamic;
//
// Funktion zur durchführung des Polarcoding-Verfahrens.
//  function getPolarArray(Bitmap : Graphics.TBitmap) : TPolarArray;
//
// Funktion zur durchführung des Polarcoding-Verfahren
// unter Berücksichtgung von Durchbrüchen sowie der Richtungsabhängigkeit
// der Kontur
//  function getPolarArrayDirection(Bitmap : Graphics.TBitmap) : TPolarArray;
//
// Funktion zum Vergleich zweier Objekte
//  function compareObjects(object1,object2 : TPolarArray;
//                          var Difference : double) : boolean;
//
// Verwendete Units:
// -----------------------------
//  unitTypes : Unit, in der benötigte Dateitypen definiert sind.
//
//
// Autoren: Alexander Bertram (2616)
//          Rüdiger Klante    (2381)
//
// erstellt am: 01.06.2006
//
// letzte Änderung: 22.06.2006
//
//------------------------------------------------------------------------------
unit unitImage;

interface

uses
  Graphics, Windows, ComCtrls, Forms, unitTypes, Classes, SysUtils,Math;

{ Prozedur zur Umwandlung eines Bildes in ein Grauwertbild }
procedure CreateGrayLevelImage(var Bitmap: Graphics.TBitmap);

{ Funktion zur Erstellung eines Histogramms aus Grauwertbildern }
function GetGrayLevelArray(Bitmap: Graphics.TBitmap): TGrayLevelArray; overload;

{ Prozedur zur Median-Filterung eines Grauwertbildes }
procedure MedianFilter(var Bitmap: Graphics.TBitmap;m : byte); overload;

{ Prozedur zur Binärbilderstellung, Verfahren von "Otsu" }
procedure CreateBinary(var Bitmap: Graphics.TBitmap);

{ Funktion zur Bestimmung des Flächenschwerpunktes eines Objektes im Bild }
function getCoG(Bitmap: Graphics.TBitmap) : TCoordinate;

{ Prozedur zum Neuladen der gesicherten Bilder }
procedure reloadImage(var Bitmap1: Graphics.TBitmap; var Bitmap2 : Graphics.TBitmap);

{ Prozedur zum Speichern des Originalbildes zum späteren Neuladen }
procedure saveForReload(Bitmap: Graphics.TBitmap; index : integer);

{ Funktion zur Ermittlung eines das Objekt im Bild umschreibenden Rechtecks }
function getRectAngle(Bitmap : Graphics.TBitmap) : TRectArray;

{ Funktion zur durchführung des Polarcoding-Verfahrens. }
function getPolarArray(Bitmap : Graphics.TBitmap) : TPolarArray;

{ Funktion zur durchführung des Polarcoding-Verfahren
  unter Berücksichtgung von Durchbrüchen sowie der Richtungsabhängigkeit
  der Kontur                                                            }
function getPolarArrayDirection(Bitmap : Graphics.TBitmap) : TPolarArray;

{ Funktion zum Vergleich zweier Objekte }
function compareObjects(object1,object2 : TPolarArray;
          var Difference : double) : boolean;

{ Funktion zur Abtastung eines Objekts an seiner Kontur entlang }
function walkTheLine(var Bitmap : Graphics.TBitmap) : TPolarArrayDynamic;


implementation

var
  SaveBitmap1,
  SaveBitmap2: Graphics.TBitmap; // Sicherungen der Ursprungsbilder


//------------------------------------------------------------------------------
// saveForReload
//------------------------------------------------------------------------------
// Prozedur zum Speichern des Originalbildes zum späteren Neuladen
//------------------------------------------------------------------------------
//Params: Bitmap -> Bild, das gespeichert wird
//        index -> Bildnummer (1 oder 2)
//------------------------------------------------------------------------------
//Globale Zugriffe: SaveBitmap1,SaveBitmap2                                    
//------------------------------------------------------------------------------
procedure saveForReload(Bitmap: Graphics.TBitmap; index : integer);
begin
  if index = 1 then
  SaveBitmap1.Assign(Bitmap)
  else SaveBitmap2.assign(Bitmap);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// reloadImage
//------------------------------------------------------------------------------
//Prozedur zum Neuladen der gesicherten Bilder
//------------------------------------------------------------------------------
//Params: var Bitmap1 -> Variable, in die Bild 1 geladen wird
//        var Bitmap2 -> Variable, in die Bild 2 geladen wird
//------------------------------------------------------------------------------
//Globale Zugriffe: SaveBitmap1,SaveBitmap2                                                             }
//------------------------------------------------------------------------------
procedure reloadImage(var Bitmap1: Graphics.TBitmap; var Bitmap2 : Graphics.TBitmap);
begin
  if SaveBitmap1 <> nil then
  Bitmap1.Assign(SaveBitmap1);
  if SaveBitmap2 <> nil then
  Bitmap2.Assign(SaveBitmap2);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// SetBMPPixel
//------------------------------------------------------------------------------
//Prozedur zum Setzen der RGB-Komponenten eines Pixels auf einen Grauwert
//------------------------------------------------------------------------------
//Params: BMPPixel (Pointer!) -> Pixel, dessen Komponenten gesetzt werden
//        Lightness -> Grauwert, auf den gesetzt wird
//------------------------------------------------------------------------------
procedure SetBMPPixel(BMPPixel: TPBMPPixel; Lightness: byte);
begin
  BMPPixel.R := Lightness;
  BMPPixel.G:= Lightness;
  BMPPixel.B:= Lightness;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// BitmapToArray
//------------------------------------------------------------------------------
//Funktion zum Umwandeln einer Bitmap in eine Bitmaparray
//zur leichteren Weiterverarbeitung
//------------------------------------------------------------------------------
//Params: Bitmap -> umzuwandelnde Bitmap
//------------------------------------------------------------------------------
//Return: TBitmapArray -> erstelltes Bitmaparray
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Grauwertbild
//------------------------------------------------------------------------------
function BitmapToArray(Bitmap: Graphics.TBitmap): TBitmapArray;
var
  x, y,           // Laufvariablen
  w, h: integer;  // Grenzen
  BMPPixel: TPBMPPixel;  // Pointer auf aktuellen Pixel
begin
  w := Bitmap.Width;
  h := Bitmap.Height;

  SetLength(Result, w);
  for x := 0 to w-1 do
    SetLength(Result[x], h);

  for y := 0 to h-1 do
  begin
    BMPPixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      Result[x, y] := BMPPixel.R;
      inc(BMPPixel);
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ArrayToBitmap
//------------------------------------------------------------------------------
//Prozedur zum Umwandeln eines Bitmaparrays in eine Bitmap
//------------------------------------------------------------------------------
//Params: var Bitmap -> Variable, in die die Bitmap geladen wird
//        BitmapArray -> Array, das in ein Bitmap gewandelt wird
//------------------------------------------------------------------------------
// Funktions/Prozeduraufrufe: SetBMPPixel
//------------------------------------------------------------------------------
procedure ArrayToBitmap(BitmapArray: TBitmapArray; var Bitmap: Graphics.TBitmap);
var
  x, y,         // Laufvariablen
  w, h: integer; // Grenzen
  BMPPixel: TPBMPPixel;   // Pointer auf aktuellen Pixel
begin
  w := Length(BitmapArray);
  h := Length(BitmapArray[0]);

  for y := 0 to h-1 do
  begin
    BMPPixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      SetBMPPixel(BMPPixel, BitmapArray[x, y]);
      inc(BMPPixel);
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// CreateGrayLevelImage
//------------------------------------------------------------------------------
//Prozedur zur Umwandlung eines Bildes in ein Grauwertbild
//durch Mittelwert aus R,G,B
//------------------------------------------------------------------------------
//Param: var Bitmap -> zu bearbeitende Bitmap
//------------------------------------------------------------------------------
procedure CreateGrayLevelImage(var Bitmap: Graphics.TBitmap);
var
  x, y: integer;   // Laufvariablen
  PBMPPixel: ^TBMPPixel; // Pointer auf aktuellen Pixel
  Lightness: byte;   // Mittelwert der RGB Kanäle
begin
  for y := 0 to Bitmap.Height - 1 do
  begin
    PBMPPixel := Bitmap.ScanLine[y];
    for x := 0 to Bitmap.Width - 1 do
    begin
      with PBMPPixel^ do
      begin
        Lightness := (R + G + B) div 3; // Mittelwert aus R,G,B
        R := Lightness;
        G := Lightness;
        B := Lightness;
      end;
      inc(PBMPPixel);
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// InitGrayLevelArray
//------------------------------------------------------------------------------
//Prozedur zur Initialisierung eines Grauwertarrays (für Histogramm)
//------------------------------------------------------------------------------
//Param: var GrayLevelArray -> Array, das initialisiert wird                                  }
//------------------------------------------------------------------------------
procedure InitGrayLevelArray(var GrayLevelArray: TGrayLevelArray);
var
  i: byte;      // Laufvariable
begin
  for i := cBack to cFront do
    GrayLevelArray[i] := 0;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// GetGrayLevelArray
//------------------------------------------------------------------------------
//Funktion zur Erstellung eines Histogramms aus Grauwertbildern
//(überladende Funktion)
//------------------------------------------------------------------------------
//Param: BMPArray -> Eingangsbild als Array
//------------------------------------------------------------------------------
//Return: TGrayLevelArray -> Histogramm
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: InitGrayLevelArray
//------------------------------------------------------------------------------
function GetGrayLevelArray(BMPArray : TBitmapArray): TGrayLevelArray; overload;
var
  x, y: integer;    // Laufvariablen
  Lightness: byte;  // Schwellwert
  GrayLevelArray: TGrayLevelArray; // Array für Histogramm
begin
  InitGrayLevelArray(GrayLevelArray);
  for x := 0 to length(BMPArray)-1 do
  begin
    for y := 0 to length(BMPArray[0])-1 do
    begin
      Lightness := BMPArray[x,y]; // Auslesen des Grauwertes an Pixel x,y
      GrayLevelArray[Lightness] := GrayLevelArray[Lightness] + 1;
        //incrementieren der Stelle im Array mit dem Index Lightness
        // -> Zählen der Grauwerthäufigkeit
    end;
  end;

  Result := GrayLevelArray;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// GetGrayLevelArray
//------------------------------------------------------------------------------
//Funktion zur Erstellung eines Histogramms aus Grauwertbildern
//(überladene Funktion) -> Arbeit wird an obige Funktion deligiert
//------------------------------------------------------------------------------
//Param: Bitmap -> Eingangsbild als Bitmap
//------------------------------------------------------------------------------
//Return: TGrayLevelArray -> Histogramm
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: BitmapToArray,GetGrayLevelArray (überladend)
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Grauwertbild
//------------------------------------------------------------------------------
function GetGrayLevelArray(Bitmap: Graphics.TBitmap): TGrayLevelArray;
var
  BitmapArray: TBitmapArray;
begin
  BitmapArray := BitmapToArray(Bitmap);
  Result := GetGrayLevelArray(BitmapArray);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// MedianFilter
//------------------------------------------------------------------------------
//Prozedur zur Median-Filterung eines Grauwertbildes (überladende Funktion)
//------------------------------------------------------------------------------
//Param: var BitmapArray -> zu filterndes Bild als BitmapArray
//       m : Größe der zu verwendenden Maske
//------------------------------------------------------------------------------
procedure MedianFilter(var BitmapArray: TBitmapArray; m: byte); overload;
type
  TMedianArray = array of byte;

  procedure InitArray(var MedianArray: TMedianArray);
  var
    i: word;
  begin
    for i := 0 to Length(MedianArray)-1 do
      MedianArray[i] := 0;
  end;

  procedure SortArray(var MedianArray: TMedianArray);
  var
    i, j, TmpByte: byte;
  begin
    for i := 0 to Length(MedianArray)-2 do
    begin
      for j := i+1 to Length(MedianArray)-1 do
      begin
        if MedianArray[i] > MedianArray[j] then
        begin
          TmpByte := MedianArray[i];
          MedianArray[i] := MedianArray[j];
          MedianArray[j] := TmpByte;
        end;
      end;
    end;
  end;
var
  x, y, x1, y1, k: integer;
  Lightness: byte;
  MedianArray: TMedianArray;
begin
  SetLength(MedianArray, sqr(m));

  k := (m - 1) div 2;

  for x := k to Length(BitmapArray)-1-k do
  begin
    for y := k to Length(BitmapArray[0])-1-k do
    begin

      InitArray(MedianArray);
      for x1 := 0 to m-1 do
      begin
        for y1 := 0 to m-1 do
        begin
          if    ((x + k - x1) < 0)
             or ((y + k - y1) < 0)
             or ((x + k - x1) >= Length(BitmapArray))
             or ((y + k - y1) >= Length(BitmapArray[0])) then
            Lightness := 0
          else
          begin
            Lightness := BitmapArray[x+k-x1, y+k-y1];
          end;
          MedianArray[x1*m+y1] := Lightness;
        end;
      end;

      SortArray(MedianArray);
      BitmapArray[x, y] := MedianArray[Length(MedianArray) div 2];
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// MedianFilter
//------------------------------------------------------------------------------
//Prozedur zur Median-Filterung eines Grauwertbildes (überladene Prozedur)
//-> deligiert Arbeit an obige Prozedur
//------------------------------------------------------------------------------
//Param: var Bitmap -> zu filterndes Bild als Bitmap
//       m : Größe der zu verwendenden Maske
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: BitmapToArray,MediamFilter (überladend),
//                           ArrayToBitmap
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Grauwertbild
//------------------------------------------------------------------------------
procedure MedianFilter(var Bitmap: Graphics.TBitmap; m: byte);  overload;
var
  BitmapArray: TBitmapArray;
begin
  BitmapArray := BitmapToArray(Bitmap);
  MedianFilter(BitmapArray, m);
  ArrayToBitmap(BitmapArray, Bitmap);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// getThreshold
//------------------------------------------------------------------------------
//Funktion zur Schwellwertbestimmung mit Verfahren nach "Otsu"
//-> globale Schwellwertbestimmung
//------------------------------------------------------------------------------
//Param: BitmapArray -> Bild, dessen Schwellwert zu ermitteln ist
//                      als BitmapArray
//------------------------------------------------------------------------------
//Return: byte -> Schwellwert
//------------------------------------------------------------------------------
function GetThreshold(BitmapArray: TBitmapArray): byte;
var
  t, g: byte;
  Histogram: TGrayLevelArray;
  // Auftrittswahrscheinlichkeiten der Grauwerte
  ProbabilityHistogram: array[byte] of double;
  // Bitmapflaeche
  N: integer;
  // Mittelwerte: Gesamt, Klasse0, Klasse1
  Mu, Mu0, Mu1,
  // Summe der Auftrittswahrscheinlichkeiten in den Klassen
  Omega0, Omega1,
  // Varianz zwischen den Klassen
  Sigma, SigmaMax: double;
begin
  GetThreshold := 0;
  Histogram := GetGrayLevelArray(BitmapArray);
  N := Length(BitmapArray)*Length(BitmapArray[0]);
  Mu := 0;
  for g := 0 to cFront do
  begin
    ProbabilityHistogram[g] := Histogram[g]/N;
    Mu := Mu+ProbabilityHistogram[g]*g;
  end;
  Mu := Mu/N;

  SigmaMax := 0;
  for t := cBack to cFront-1 do
  begin
    Omega0 := 0;
    Mu0 := 0;
    for g := cBack to t do
    begin
      Omega0 := Omega0+ProbabilityHistogram[g];
      Mu0 := Mu0+ProbabilityHistogram[g]*g;
    end;
    if Omega0 = 0 then
      Mu0 := 0
    else
      Mu0 := Mu0/Omega0;

    Omega1 := 0;
    Mu1 := 0;
    for g := t+1 to cFront do
    begin
      Omega1 := Omega1+ProbabilityHistogram[g];
      Mu1 := Mu1+ProbabilityHistogram[g]*g;
    end;
    if Omega1 = 0 then
      Mu1 := 0
    else
      Mu1 := Mu1/Omega1;

    Sigma := Omega0*sqr(Mu0-Mu)+Omega1*sqr(Mu1-Mu);
    if Sigma > SigmaMax then
    begin
      SigmaMax := Sigma;
      Result := t;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// CreateBinary
//------------------------------------------------------------------------------
//Prozedur zur Binärbilderstellung mittels eines Schwellwertes, der per
//Verfahren nach "Otsu" (obige Funktion) ermittelt wurde
//------------------------------------------------------------------------------
//Param: var Bitmap -> zu binarisierendes Bild als Bitmap
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: GetGrayLevelArray, BitmapToArray, getThreshold,
//                           ArrayToBitmap
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Grauwertbild
//------------------------------------------------------------------------------
procedure CreateBinary(var Bitmap: Graphics.TBitmap);
var
  x, y: integer;    // Laufvariablen
  Lightness: byte;  // Schwellwert
  TmpBitmap: Graphics.TBitmap;  // temporäre Bitmap
  GrayArray : TGrayLevelArray;  // Array für Histogramm
  BMPArray : TBitmapArray;      // Bitmaparray
begin
  TmpBitmap := Graphics.TBitmap.Create;
  TmpBitmap.Assign(Bitmap);

  GrayArray := GetGrayLevelArray(Bitmap);  // Erstellen des Histogramms

  BMPArray := BitmapToArray(Bitmap);  // Umwandeln Bitmap->Array
  Lightness := getThreshold(BMPArray); // Schwellwert ermitteln

  for y := 0 to Bitmap.Height-1 do
  begin
    for x := 0 to Bitmap.Width-1 do
    begin
      if BMPArray[x,y] < Lightness then  // wenn Grauwert des aktuellen Pixels
         BMPArray[x,y] := cFront         // kleiner als Schwellwert wird
      else                               // Pixel auf Vordergrund (cFront),
        BMPArray[x,y] := cBack;          // sonst auf Hintergrund (cBack) gesetzt
    end;
  end;

 ArrayToBitmap(BMPArray,TmpBitmap); // Umwandlung Array->Bitmap
 Bitmap.Assign(TmpBitmap);
 TmpBitmap.Free;
end;
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// getRectAngle
//------------------------------------------------------------------------------
//Funktion zur Ermittlung eines das Objekt im Bild umschreibenden Rechtecks
//zur späteren Bestimmung des Flächenschwerpunktes.
//Das Rechteck dient dort als Eingrenzung des Bereiches, auf den das
//Schwerpunktverfahren angewendet wird. Hierdurch können Fehler durch
//Rauschen verringert werden.
//------------------------------------------------------------------------------
//Param: Bitmap -> Bild, den dem Objekt gefunden werden soll als Bitmap
//------------------------------------------------------------------------------
//Return: TRectArray -> Array mit den vier Rechteckkoordinaten
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: BitmapToArray
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Binärbild
//------------------------------------------------------------------------------
function getRectAngle(Bitmap : Graphics.TBitmap) : TRectArray;
var
  x, y: integer;  // Laufvariablen
  tmpX1,tmpX2,tmpY1,tmpY2 : integer;  // temporäre Koordinaten
  finalX1,finalX2,finalY1,finalY2,max_X,max_Y : integer; // endgültige Koordinaten
  BMPArray : TBitmapArray;  // Bitmaparray
  P1,P2,P3,P4 : TCoordinate;  // gefundene Extrempunkte
  sqP1,sqP2,sqP3,sqP4 : TCoordinate;  // errechnete Rechteckpnukte
begin
  BMPArray := BitmapToArray(Bitmap); //Umwandlung Bitmap->Array

  // Initialisierung
  max_X := Bitmap.Width-1;
  max_Y := Bitmap.Height-1;
  finalX1 := max_X;
  finalX2 := 0;
  finalY1 := 0;
  finalY2 := 0;

  // Bestimmung der horizontalen Minima und Maxima im Objekt
  for y := 0 to max_Y do
  begin
    for x := 0 to max_X-1 do
    begin
      if     (BMPArray[x,y] = cBack)
         and (BMPArray[x+1,y] = cFront) then
      begin
        tmpX1 := x;
        tmpX2 := x;
        while     (tmpX2 < max_X)
              and (BMPArray[tmpX2+1,y] <> cBack) do
        begin
          inc(tmpX2);
        end;
         if     (tmpX2-tmpX1 > 10)
            and (tmpX1 < finalX1) then
         begin
          finalX1 := tmpX1;
          finalY1 := y;
         end;

         if     (tmpX2-tmpX1 > 10)
            and (tmpX2 > finalX2) then
         begin
           finalX2 := tmpX2;
           finalY2 := y;
         end;
      end;
    end;
  end;

  // horizontales Minimum
  P1.x := finalX1;
  P1.y := finalY1;
  // horizontales Maximum
  P2.x := finalX2;
  P2.y := finalY2;

  // Initialisierung
  finalX1 := 0;
  finalX2 := 0;
  finalY1 := max_Y;
  finalY2 := 0;

  // Bestimmung der vertikalen Minima und Maxima im Objekt
  for x := 0 to max_X do
  begin
    for y := 0 to max_Y-1 do
    begin
      if     (BMPArray[x,y] = cBack)
         and (BMPArray[x,y+1] = cFront) then
      begin
        tmpY1 := y;
        tmpY2 := y;
        while     (tmpY2 < max_Y)
              and (BMPArray[x,tmpY2+1] <> cBack) do
        begin
          inc(tmpY2);
        end;
         if     (tmpY2-tmpY1 > 10)
            and (tmpY1 < finalY1) then
         begin
          finalX1 := x;
          finalY1 := tmpY1;
         end;

         if     (tmpY2-tmpY1 > 10)
            and (tmpY2 > finalY2) then
         begin
           finalX2 := x;
           finalY2 := tmpY2;
         end;

      end;
    end;
  end;

  // vertikales Maximum
  P3.x := finalX1;
  P3.y := finalY1;
  // vertikales Minimum
  P4.x := finalX2;
  P4.y := finalY2;

  // Punkte des umschreibenden Vierecks zuordnen
  sqP1.x := P1.x;
  sqP1.y := P3.y;
  sqP2.x := P2.x;
  sqP2.y := P3.y;
  sqP3.x := P2.x;
  sqP3.y := P4.y;
  sqP4.x := P1.x;
  sqP4.y := P4.y;

  // Rückgabe der ermittelten Koordinaten
  getRectAngle[0] := sqP1;
  getRectAngle[1] := sqP2;
  getRectAngle[2] := sqP3;
  getRectAngle[3] := sqP4;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// getCoG
//------------------------------------------------------------------------------
//Funktion zur Bestimmung des Flächenschwerpunktes eines Objektes im Bild.
//Hierzu wird der jeweils der Mittelwert der x und y Koordinaten
//aller Objektpunkte ermittelt.
//Zur Vermeidung von Fehlern durch eventuell noch vorhandenes Rauschen
//wird die Mittlung über die Objektpunkte nur in einem vorher ermittelten,
//das Objekt umschreibenden Rechteck durchgeführt.
//------------------------------------------------------------------------------
//Param: Bitmap -> zu untersuchendes Bild als Bitmap
//------------------------------------------------------------------------------
//Return: TCoordinate -> Koordinaten des Schwerpunktes
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: getRectAngle, BitmapToArray
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Binärbild
//------------------------------------------------------------------------------
function getCoG(Bitmap: Graphics.TBitmap) : TCoordinate;
var
  RectArray : TRectArray;  // Eckpunkte des umschreibenden Rechtecks
  x,y,          // Koordinaten
  xSum,ySum,    // Summen der Koordinaten
  pixelSum : integer;  // Summe der Pixel
  BMPArray : TBitmapArray;  // Bitmaparray
begin
  RectArray := getRectAngle(Bitmap); // Rechteck ermitteln
  BMPArray := BitmapToArray(Bitmap); // Umwandlung Bitmap->Array

  // Initialisierung
  xSum := 0;
  ySum := 0;
  pixelSum := 0;

  for x := RectArray[0].x to RectArray[1].x do
   for y := RectArray[0].y to RectArray[3].y do
   begin
     if BMPArray[x,y] = cFront then   // Wenn Pixel zum Vordergrund gehört
     begin                            // werden die Summen der x und y
       xSum := xSum + x;              // Koordinaten um die aktuellen
       ySum := ySum + y;              // Koordinaten erhöht
       inc(Pixelsum)                  // und die Pixelsumme incrementiert
     end;
   end;

   // Rückgabe der Schwerpunktskoordinaten
   getCoG.x := xSum div pixelSum;  //-> Mittelwert der x-Koordinaten
   getCoG.y := ySum div pixelSum;  //-> Mittelwert der y-Koordinaten

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// initPolarArray
//------------------------------------------------------------------------------
//Funktion zur Initialisierung eines Arrays für Ergebnisse des Polarcodings
//------------------------------------------------------------------------------
//Return: TPolarArray -> initialisiertes Array
//------------------------------------------------------------------------------
function initPolarArray : TPolarArray;
var i : TAngleSteps; // Laufvariable
begin
  for i := low(TAngleSteps) to high(TAngleSteps) do
     initPolarArray[i] := 0;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// getPolarArray
//------------------------------------------------------------------------------
//Funktion zur durchführung des Polarcoding-Verfahrens.
//Hierzu wird in TAnglesteps Winkelschritten jeweils der Abstand (die Pixelzahl)
//vom Flächenschwerpunkt zum Rand des Objektes gemessen und in einem
//TPolarArray am Index des jeweils verwendeten Winkels gespeichert.
//------------------------------------------------------------------------------
//Param: Bitmap -> zu untersuchendes Bild als Bitmap
//------------------------------------------------------------------------------
//Return: TPolarArray -> Array mit den Ergebnissen des Polarcodings
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: initPolarArray, getCoG, BitmapToArray
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Binärbild
//------------------------------------------------------------------------------
function getPolarArray(Bitmap : Graphics.TBitmap) : TPolarArray;
var CoG : TCoordinate;   // Schwerpunkt
    currentAnglePos : TAngleSteps;  // aktuelle Winkelposition
    tmpPxlCount : integer;  // Pixelmenge auf dem Strahl
    tmpPolarArray : TPolarArray;  // temporäres Polararray
    length,         // aktuelle Strahllänge
    x,y : integer;  // aktuelle Koordinaten
    BMPArray : TBitmapArray;  // Bitmaparray
    angle : double;  // aktueller Winkel
begin
  CoG := getCoG(Bitmap);  // Ermittlung des Schwerpunktes
  tmpPolarArray := initPolarArray;  // Initialisierung
  BMPArray := BitmapToArray(Bitmap);  // Umwandlung Bitmap->Array

  for currentAnglePos := low(TAngleSteps) to high(TAngleSteps) do
  begin
    // Initialisierung
    length := 1;
    x := CoG.x;  // Setzen x-Startwert auf Schwerpunkt
    y := CoG.y;  // Setzen y-Startwert auf Schwerpunkt
    tmpPxlCount := 0;

    angle := (currentAnglePos/cNormalizeAngle) *((2*Pi)/360);
          // Berechnung des aktuellen Winkels incl. Umrechnung ins Bogenmaß

    while   ((x < Bitmap.Width) and (y < Bitmap.Height))
        and ((x >= 0) and (y >= 0))
        and (BMPArray[x,y] <> cBack)do
    begin
      // Berechnung der nächsten Koordinate entlang des Strahls
      // vom Schwerpunkt aus im aktuellen Winkel
      x := CoG.x + round(cos(angle) * length);
      y := CoG.y + round(sin(angle) * length);

      inc(tmpPxlCount); // Pixel mitzählen
      inc(length);
    end;
    tmpPolarArray[currentAnglePos] := tmpPxlCount; // Eintragen des Ergebnisses
                                                   // für aktuellen Winkel
                                                   // in Ergebnisarray
  end;

  getPolarArray := tmpPolarArray; // Rückgabe des Ergebnisses

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// compareObjects
//------------------------------------------------------------------------------
//Funktion zum Vergleich zweier Objekte anhand der sie Charakterisierenden
//TPolararrays (also ihrer Ergebnisse aus dem Polarcoding.
//Hierzu wird mit einem Versatz von low(TAngleSteps) bis high(TAnglesteps)
//parallel durch beide Arrays gelaufen und jeweils die Differenz des jeweiligen
//Indexes gebildet. Liegt diese unter einer Tolerant von 10 Pixeln, wird dies
//als Übereinstimmung gewertet.
//Bei Nichtübereinstimmung wird die Zahl der Fehler (errors) erhöht.
//Sollte diese Zahl nach einem kompletten Durchlauf für einen Versatzwert
//unter der Toleranz cErrorTolerance liegen, werden die beiden Bilder als
//übereinstimmend gewertet.
//Schließlich wird bei übereinstimmenden Bildern der Quotient aus Versatz
//und der Konstante cNormalizeAngle gebildet und als Winkeldifferenz
//zurückgeliefert
//------------------------------------------------------------------------------
//Param: object1,object2 -> Polarcodierte Repräsentationen zweier Objekte
//       var Difference -> errechnete Winkeldifferenz
//------------------------------------------------------------------------------
//Return: boolean -> true, wenn Bilder identisch, sonst false
//------------------------------------------------------------------------------
function compareObjects(object1,object2 : TPolarArray;
          var Difference : double) : boolean;
var equal : boolean;    // temporäre gleichheit
    versatz,            // aktueller index
    index : TAngleSteps;  // aktueller versatz
    errors,      // zahl aufgetretener Fehler
    greaterzero,  // Polarwerte groesser 0
    diff : integer;  // temporärer differentwert
begin
  // Initialisierung
  Difference := 0;
  compareObjects := false;
  greaterzero := 0;

  for versatz := low(TAngleSteps) to high(TAngleSteps) do
  begin
  errors := 0; // Fehler zurücksetzen
  for index := low(TAngleSteps) to high(TAngleSteps) do
  begin
    // Differenz der Absolutwerte errechnen
    diff :=
    (abs(object1[index]) - abs(object2[(index+versatz) mod (high(TAngleSteps)+1)]));

    if   (object1[index] > 0)
      or (object2[(index+versatz) mod (high(TAngleSteps)+1)] > 0)
    then inc(greaterzero);
    // Differenz unter Berücksichtigung von Toleranz bewerten
    equal := (diff < 10) and (diff > -10);

    if (not equal) then inc(errors); // Fehler ggf. erhöhen
  end;

    if (errors < cErrorTolerance) then  // wenn Fehlertoleranz unterschritten
    begin
      if (greaterzero <> 0) then
      compareObjects := true;            // true zurückgeben
      Difference := versatz / cNormalizeAngle;  // Winkeldifferenz berechnen
      break;                             // und Schleife verlassen
    end;
  end;
end;
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// getFirstObjectPixel
//------------------------------------------------------------------------------
// Hilfsfunktion zur Berechnung der Koordinaten des ersten Objektpixels im Bild
//------------------------------------------------------------------------------
//Param: Bitmap -> zu untersuchendes Bild als Bitmap
//------------------------------------------------------------------------------
//Return: TCoordinate -> Koordinaten des gesuchten Pixels
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: BitmapToArray
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Binärbild
//------------------------------------------------------------------------------
function getFirstObjectPixel(Bitmap : Graphics.TBitmap) : TCoordinate;
var x,y : integer;    // aktuelle Koordinaten
    BMPArray : TBitmapArray;  // Bitmaparray
    found : boolean;   // Pixel gefunden?
begin
  getFirstObjectPixel.x := 0;
  getFirstObjectPixel.y := 0;
  BMPArray := BitmapToArray(Bitmap);
  found := false;
  for y := 0 to length(BMPArray[0])-1 do
   for x := 0 to length(BMPArray)-1 do
   begin
    if BMPArray[x,y] = cFront then
    begin
      getFirstObjectPixel.x := x;
      getFirstObjectPixel.y := y;
      found := true;
      break;
    end;
    if found then break;
   end;

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// checkDirection
//------------------------------------------------------------------------------
// Hilfsfunktion zum Überprüfen, ob ein Pixel in einer Richtung (0-7)
// gesetzt ist
//------------------------------------------------------------------------------
//Param: direction -> zu überprüfende Richtung
//       currentX,currentY -> Koordinaten, von denen aus geprüft wird
//       BMPArray -> Bild, in dem geprüft wird als TBitmapArray
//------------------------------------------------------------------------------
//Return: boolean -> Richtung gesetzt/nicht gesetzt
//------------------------------------------------------------------------------
function checkDirection(direction: TDirectionSteps;
                          currentX,currentY : integer;
                          BMPArray : TBitmapArray) : boolean;
begin
  checkDirection := false;
  if  ((currentX > 0) and (currentX < length(BMPArray)))
  and ((currentY > 0) and (currentY < length(BMPArray[0]))) then
  case direction of
    0: checkDirection := BMPArray[currentX+1,currentY] <> cBack;
    1: checkDirection := BMPArray[currentX+1,currentY+1] <> cBack;
    2: checkDirection := BMPArray[currentX,currentY+1] <> cBack;
    3: checkDirection := BMPArray[currentX-1,currentY+1] <> cBack;
    4: checkDirection := BMPArray[currentX-1,currentY] <> cBack;
    5: checkDirection := BMPArray[currentX-1,currentY-1] <> cBack;
    6: checkDirection := BMPArray[currentX,currentY-1] <> cBack;
    7: checkDirection := BMPArray[currentX+1,currentY-1] <> cBack;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// doStep
//------------------------------------------------------------------------------
// Hilfsprozedur zum Ausführen eines Schrittes aus TDirectionSteps (0-7)
//------------------------------------------------------------------------------
//Param: step -> Richtung, in die der Schritt ausgeführt werden soll
//       var currentX,currentY -> Koordinaten, von denen aus der Schritt
//                                ausgeführt werden soll
//       var Pixelcount -> Anzahl der Konturpixel, die hier erhöht wird
//------------------------------------------------------------------------------
procedure doStep(var Pixelcount : integer; var CurrentX : integer;
                 var CurrentY : integer; step : TDirectionSteps);
begin
  case step of
  0: begin
      inc(PixelCount);
      inc(currentX);
     end;
  1: begin
      inc(PixelCount);
      inc(currentY);
      inc(currentX);
     end;
  2: begin
      inc(PixelCount);
      inc(currentY);
     end;
  3: begin
      dec(currentX);
      inc(currentY);
      inc(PixelCount);
     end;
  4: begin
      dec(currentX);
      inc(PixelCount);
     end;
  5: begin
      inc(PixelCount);
      dec(currentX);
      dec(currentY);
     end;
  6: begin
      inc(PixelCount);
      dec(currentY);
     end;
  7: begin
      inc(PixelCount);
      inc(currentX);
      dec(currentY);
     end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// walkTheLine
//------------------------------------------------------------------------------
// In dieser Funktion wird auf der Kontur des im Bild befindlichen Objekts
// entlang "gegangen" und von jedem Konturpunkt der Abstand zum Flächen-
// schwerpunkt berechnet. Die berechneten Abstände werden in einem dynamischen
// Array zurückgeliefert.
// Weiterhin wird auf der Bitmap der gegangene Weg rot markiert.
//------------------------------------------------------------------------------
//Param: var Bitmap -> Bild, in dem der Rand des Objekts abgefahren und
//                     markiert wird (als Bitmap)
//------------------------------------------------------------------------------
//Return: TPolarArrayDynamic -> Array mit berechneten Abständen zur Kontur
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: getFirstObjectPixel, BitmapToArray, checkDirection,
//                           doStep, getCoG
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Binärbild
//------------------------------------------------------------------------------
function walkTheLine(var Bitmap : Graphics.TBitmap) : TPolarArrayDynamic;
var firstPixel : TCoordinate; // erster Pixel des Bildes
    currentX,currentY,       // aktuelle Koordinaten
    currentStepAngle,        // aktuelle Schrittrichtung
    PixelCount : integer;    // Zahl der abgetasteten Pixel
    BMPArray : TBitmapArray;  // Bitmaparray
    CoG : TCoordinate;        // Flächenschwerpunkt

begin

  firstPixel := getFirstObjectPixel(Bitmap); // ersten Objektpunkt finden
  // Initialisierung
  currentX := firstPixel.x;
  currentY := firstPixel.y;
  PixelCount := 0;

  BMPArray := BitmapToArray(Bitmap);   // Bitmaparray erstellen
  CoG := getCoG(Bitmap);    // Schwerpunkt bestimmen

  Bitmap.Canvas.MoveTo(currentX,currentY);

  while     ( not(    (currentX = firstPixel.x)
                and (currentY = firstPixel.y)))
        or  (PixelCount = 0) do
   begin
    currentStepAngle := cMinDirectionAngle;
    // solange im kreis laufen, bis ein Pixel nichtmehr zum Objekt gehört
    while checkDirection(currentStepAngle,currentX,currentY,BMPArray) do
      inc(currentStepAngle);

    // solange im Kreis laufen, bis ein Pixel wieder zum Objekt gehört
    while (not checkDirection(currentStepAngle mod cMaxDirectionAngle+1,
                              currentX,currentY,BMPArray)) do
      inc(currentStepAngle);

    inc(currentStepAngle);
    // Normierung des Schrittwinkels
    currentStepAngle := currentStepAngle mod (cMaxDirectionAngle+1);
    // errechneten Schritt ausführen
    doStep(PixelCount,currentX,currentY,currentStepAngle);
    // ausgeführten Schritt visualisieren
    Bitmap.Canvas.Pen.Color :=clRed;
    Bitmap.canvas.pen.width := 3;
    Bitmap.Canvas.LineTo(currentX,currentY);
    // Länge des errechneten nächten Konturpixels in Ergebnisarray eintragen
    setLength(result,PixelCount);
    result[PixelCount-1] :=
    round(sqrt(power(CoG.x-currentX,2) + power(CoG.y-currentY,2)));
   end;

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// getCurvesOfArray
//------------------------------------------------------------------------------
// Prozedur, die ein erstelltes Polararray hinsichtlich der Richtungs-
// abhängigkeit der Kontur modifiziert.
// Der sehr einfache Algorithmus betrachtet dabei Zwei Abtastwerte jeweils
// 5 Winkelschritte vom Referenzwert entfernt. Sind diese Werte beide kleiner
// als der Referenzwert, wird dies als positive Krümmung erkannt.
// Anderenfalls wird der aktuelle Referenzwert negiert, was eine negative
// Krümmung darstellt.
//------------------------------------------------------------------------------
//Param: var polarArray -> Ergebnis einer Polarabtastung, in dem die Krümmungen
//                         bewertet werden
//------------------------------------------------------------------------------
procedure getCurvesOfArray(var polarArray : TPolarArray);
var currentAnglePos : integer;
    tmpArray : TPolarArray;
begin
  tmpArray := polarArray;
  for currentAnglePos := low(TAngleSteps) to high(TAngleSteps) do
  begin
    if    (tmparray[currentAnglePos] <
            (tmparray[((cMaxAngle+currentAnglePos-4) mod (cMaxAngle+1))]+10))
      and (tmparray[currentAnglePos] <
            (tmparray[(currentAnglePos+5) mod (cMaxAngle+1)]+10))
    then polarArray[currentAnglePos] := polarArray[currentAnglePos] * 1
    else polarArray[currentAnglePos] := polarArray[currentAnglePos] * -1;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// getAverageArray
//------------------------------------------------------------------------------
// Prozedur zur Mittelwertbildung aus einem durch Polarcoding erstellten
// Arrays, bei dem mehrere Schnittpunkte je Winkelschritt möglich sind.
// Gemittelt werden die Schnittpunkte je Winkelschritt.
//------------------------------------------------------------------------------
//Param: var polarArray -> Ergebnis einer Polarabtastung mit mehrfachen
//                         Schnittpunkten, in dem Mittelwerte gebildet werden
//------------------------------------------------------------------------------
//Return: TPolarArray -> Array mit einfachen Werten je Winkelschritt, erstellt
//                       durch Mittelwertbildung
//------------------------------------------------------------------------------
function getAverageArray(polarray : TPolarArrayMultiJunction) : TPolarArray;
var currentAnglePos, // Index des aktuellen Winkels
    currentJunction, // Index des aktuellen Schnittpunkts je Winkel
    akku : integer;  // akkumulator zur Mittelwertsbildung
begin
  for currentAnglePos := cMinAngle to cMaxAngle do
  begin
    akku := 0;
    if not (length(polarray[currentAnglePos]) = 0)
    then begin
    for currentJunction := 0 to length(polarray[currentAnglePos])-1 do
      akku := akku + polarray[currentAnglePos,currentJunction];
    result[currentAnglePos] := akku div length(polarray[currentAnglePos])
    end
    else result[currentAnglePos] := 0;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// getPolarArrayDirection
//------------------------------------------------------------------------------
// Funktion zur durchführung des Polarcoding-Verfahrens.
// Hierzu wird in TAnglesteps Winkelschritten jeweils der Abstand (die Pixelzahl)
// vom Flächenschwerpunkt zu den Übergängen zwischen Objekte und Hintergrund
// gemessen und in einem TPolarArrayMultiJunction am Index des jeweils
// verwendeten Winkels sowie der jeweiligen Nummer des Schnittpunktes mit
// dem Objekt gespeichert.
// Im Anschluss wird, im Fall mehrerer Schnittpunkte für einen Winkelschritt,
// der Mittelwert aus den Abtastwerten je Winkelschritt gebildet.
// Vor der Rückgabe der errechneten Werte wird noch die Richtungsabhängigkeit
// der Kontur in die Ergebnisse eingerechnet.
//------------------------------------------------------------------------------
//Param: Bitmap -> zu untersuchendes Bild als Bitmap
//------------------------------------------------------------------------------
//Return: TPolarArray -> Array mit den Ergebnissen des Polarcodings
//------------------------------------------------------------------------------
//Funktions/Prozeduraufrufe: initPolarArray, getCoG, BitmapToArray,
//                           getAverageArray, getCurvesOfArray
//------------------------------------------------------------------------------
//Vorbedingung: Bitmap ist Binärbild
//------------------------------------------------------------------------------
function getPolarArrayDirection(Bitmap : Graphics.TBitmap) : TPolarArray;
var CoG : TCoordinate; // Flächenschwerpunkt
    currentAnglePos : TAngleSteps; // aktueller Winkelindex
    tmpPxlCount,   // gesamte Pixelzahl je Abtaststrahl
    bgPxlCount,    // Hintergrundspixel je Abtaststrahl
    frPxlCount : integer; // Vordergrundspixel je Abtaststrahl
    length,        // aktuelle Laenge des Abtaststrahls
    x,y : integer; // Aktuelle Koordinaten auf dem Abtaststrahl
    BMPArray : TBitmapArray; // Bitmaparray
    angle : double; // aktueller Winkel des Abtaststrahls
    junctions : integer;  // Zahl der Schnittpunkte auf Abtaststrahl
    polarArrayMultiJunction : TPolarArrayMultiJunction;
                       // Polararray mit mehreren Abständen
    polarArray : TPolarArray; // Polararray mit Abständen (gemittelt)
begin

  CoG := getCoG(Bitmap);  // Ermittlung des Schwerpunktes
  polarArray := initPolarArray;  // Initialisierung
  BMPArray := BitmapToArray(Bitmap);  // Umwandlung Bitmap->Array

  for currentAnglePos := low(TAngleSteps) to high(TAngleSteps) do
  begin
    // Initialisierung
    length := 1;
    x := CoG.x;  // Setzen x-Startwert auf Schwerpunkt
    y := CoG.y;  // Setzen y-Startwert auf Schwerpunkt
    tmpPxlCount := 0;  // Pixelzahlen zurücksetzen
    junctions := 0;    // Zahl der Schnittpunkte zurücksetzen

    angle := (currentAnglePos/cNormalizeAngle) *((2*Pi)/360);
          // Berechnung des aktuellen Winkels incl. Umrechnung ins Bogenmaß

    while     ((x > 0) and (y > 0))
         and  ((x < Bitmap.Width) and (y < Bitmap.Height)) do
    begin
      bgPxlCount := 0;   // Pixelzahlen zurücksetzen
      frPxlCount := 0;
      while   ((x > 0) and (y > 0))
          and ((x < Bitmap.Width) and (y < Bitmap.Height))
          and (BMPArray[x,y] <> cFront) do
      begin
        // Berechnung der nächsten Koordinate entlang des Strahls
        // vom Schwerpunkt aus im aktuellen Winkel
        x := CoG.x + round(cos(angle) * length);
        y := CoG.y + round(sin(angle) * length);

        inc(bgPxlCount); // Pixel mitzählen
        inc(length);
      end;

      if      (bgPxlCount > 2)
         and  ((x <> CoG.x) or (y <> CoG.y))
         and  ((x > 0) and (y > 0))
         and  ((x < Bitmap.Width) and (y < Bitmap.Height)) then
      begin
        junctions := junctions + 1;
        tmpPxlCount := tmpPxlCount + bgPxlCount;
        setLength(polarArrayMultiJunction[currentAnglePos],junctions);
        polarArrayMultiJunction[currentAnglePos,junctions-1] := tmpPxlCount;
      end;

      while   ((x > 0) and (y > 0))
          and ((x < Bitmap.Width) and (y < Bitmap.Height))
          and (BMPArray[x,y] <> cBack)do
      begin
        // Berechnung der nächsten Koordinate entlang des Strahls
        // vom Schwerpunkt aus im aktuellen Winkel
        x := CoG.x + round(cos(angle) * length);
        y := CoG.y + round(sin(angle) * length);

        inc(frPxlCount); // Pixel mitzählen
        inc(length);
      end;
      if      (frPxlCount > 2)
         and  ((x <> CoG.x) or (y <> CoG.y))
         and  ((x > 0) and (y > 0))
         and  ((x < Bitmap.Width) and (y < Bitmap.Height)) then
      begin
        junctions := junctions + 1;
        tmpPxlCount := tmpPxlCount + frPxlCount;
        setLength(polarArrayMultiJunction[currentAnglePos],junctions);
        polarArrayMultiJunction[currentAnglePos,junctions-1] := tmpPxlCount;
      end;

    end;
    if junctions > 1 then
     junctions := junctions;
    if junctions = 0 then
    begin
    setLength(polarArrayMultiJunction[currentAnglePos],1);
    polarArrayMultiJunction[currentAnglePos,0] := 0;
    end;
  end;

  polarArray := getAverageArray(polarArrayMultiJunction); // Mittlung über die
                                                          // aufgetretenen
                                                          // Schnittpunkte je
                                                          // Winkel

  getCurvesOfArray(polarArray);  // Bewertung der Krümmung der Kontur

  result := polarArray;
end;
//------------------------------------------------------------------------------


initialization
  SaveBitmap1 := Graphics.TBitmap.Create;
  SaveBitmap2 := Graphics.TBitmap.Create;

finalization
  SaveBitmap1.Free;
  SaveBitmap2.Free;

end.
