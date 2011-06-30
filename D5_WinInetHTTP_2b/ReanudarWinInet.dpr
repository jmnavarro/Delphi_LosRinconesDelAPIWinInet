program ReanudarWinInet;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  HiloDescargaEventos in 'HiloDescargaEventos.pas',
  HiloDescarga in 'HiloDescarga.pas',
  Hilo in 'Hilo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Reanudar la descarga con WinInet';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
