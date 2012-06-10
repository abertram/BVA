//------------------------------------------------------------------------------
// Name der Unit: unitTypes
//
// Projekt: bva.dpr
// In diesem Praktikum sollen Algorithmen zur Polarabtastung implementiert
// und ihre Anwendnugsmöglichkeiten, aber auch ihre Grenzen experimentell
// untersucht werden.
//
//
//
// Diese Unit enthaelt alle eigenen Datentypen
//
// Autoren: Alexander Bertram (2616)
//          Rüdiger Klante    (2381)
//
// erstellt am: 01.06.2006
//
// letzte Änderung: 22.06.2006
//
//------------------------------------------------------------------------------
unit unitTypes;

interface

const
  cMinDirectionAngle = 0;  // minimaler Richtungsindex
  cMaxDirectionAngle = 7;  // maximaler Richtungsindex
  cMinAngle = 0;  // Anfangswinkel für Polarcoding
  cMaxAngle = 719; // Endwinkel für Polarcoding
  cNormalizeAngle = cMaxAngle/360; // Konstante zur Normalisierung der Winkel-
                                   // schritte auf 360°
  cAngleStepSize = 360/cMaxAngle; // Schrittgröße für Winkel bei Polarcoding
  cErrorTolerance = 50 * (cMaxAngle div 360); // Fehlertoleranz für Objekterkennung
  cBack = low(byte);  // Hintergrund
  cFront = high(byte);  // Vordergrund
type

  TDirectionSteps = cMinDirectionAngle..cMaxDirectionAngle; // Datentyp für
                                                            // Konturabtastung

  TPolarArrayDynamic = array of integer;  // Array für Konturabtastung

  TAngleSteps = cMinAngle..cMaxAngle; // Datentyp für Winkel im Polarcoding

  TGrayLevelArray = array [byte] of integer;  // Grauwertarray -> Histogramm

  TBitmapArray = array of array of byte; // Bitmaparray für Umwandlung Bitmap
                                         // in "schnelleren" Datentyp

  TBMPPixel = record   // Abbildung eines Pixels mit den Farbkomponenten
    R, G, B: byte;     // Rot, Grün, Blau
  end;

  TPBMPPixel = ^TBMPPixel;  // Pointer auf TBMPPixel

  TCoordinate = record   // Datentyp für Koordinaten
    x,y : integer;
  end;

  TRectArray = array[0..3] of TCoordinate;  // Array für die Vier Eckpunkte
                                            // eines Rechtecks

  TPolarArray = array[TAngleSteps] of integer;  // Array für Ergebnisse des
                                                // Polarcoding

  // Array für Ergebnisse des Polarcoding bei Berücksichtigung mehrerer
  // Schnittpunkte
  TPolarArrayMultiJunction = array[TAngleSteps] of array of integer;

implementation

end.
