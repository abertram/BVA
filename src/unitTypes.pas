//------------------------------------------------------------------------------
// Name der Unit: unitTypes
//
// Projekt: bva.dpr
// In diesem Praktikum sollen Algorithmen zur Polarabtastung implementiert
// und ihre Anwendnugsm�glichkeiten, aber auch ihre Grenzen experimentell
// untersucht werden.
//
//
//
// Diese Unit enthaelt alle eigenen Datentypen
//
// Autoren: Alexander Bertram (2616)
//          R�diger Klante    (2381)
//
// erstellt am: 01.06.2006
//
// letzte �nderung: 22.06.2006
//
//------------------------------------------------------------------------------
unit unitTypes;

interface

const
  cMinDirectionAngle = 0;  // minimaler Richtungsindex
  cMaxDirectionAngle = 7;  // maximaler Richtungsindex
  cMinAngle = 0;  // Anfangswinkel f�r Polarcoding
  cMaxAngle = 719; // Endwinkel f�r Polarcoding
  cNormalizeAngle = cMaxAngle/360; // Konstante zur Normalisierung der Winkel-
                                   // schritte auf 360�
  cAngleStepSize = 360/cMaxAngle; // Schrittgr��e f�r Winkel bei Polarcoding
  cErrorTolerance = 50 * (cMaxAngle div 360); // Fehlertoleranz f�r Objekterkennung
  cBack = low(byte);  // Hintergrund
  cFront = high(byte);  // Vordergrund
type

  TDirectionSteps = cMinDirectionAngle..cMaxDirectionAngle; // Datentyp f�r
                                                            // Konturabtastung

  TPolarArrayDynamic = array of integer;  // Array f�r Konturabtastung

  TAngleSteps = cMinAngle..cMaxAngle; // Datentyp f�r Winkel im Polarcoding

  TGrayLevelArray = array [byte] of integer;  // Grauwertarray -> Histogramm

  TBitmapArray = array of array of byte; // Bitmaparray f�r Umwandlung Bitmap
                                         // in "schnelleren" Datentyp

  TBMPPixel = record   // Abbildung eines Pixels mit den Farbkomponenten
    R, G, B: byte;     // Rot, Gr�n, Blau
  end;

  TPBMPPixel = ^TBMPPixel;  // Pointer auf TBMPPixel

  TCoordinate = record   // Datentyp f�r Koordinaten
    x,y : integer;
  end;

  TRectArray = array[0..3] of TCoordinate;  // Array f�r die Vier Eckpunkte
                                            // eines Rechtecks

  TPolarArray = array[TAngleSteps] of integer;  // Array f�r Ergebnisse des
                                                // Polarcoding

  // Array f�r Ergebnisse des Polarcoding bei Ber�cksichtigung mehrerer
  // Schnittpunkte
  TPolarArrayMultiJunction = array[TAngleSteps] of array of integer;

implementation

end.
