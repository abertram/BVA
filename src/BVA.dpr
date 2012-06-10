program BVA;

uses
  Forms,
  unitMain in 'unitMain.pas' {FormBVA},
  unitImage in 'unitImage.pas',
  unitTypes in 'unitTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormBVA, FormBVA);
  Application.Run;
end.
