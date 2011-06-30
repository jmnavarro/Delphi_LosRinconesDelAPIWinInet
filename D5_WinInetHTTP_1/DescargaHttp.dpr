program DescargaHttp;

uses
  Forms, Windows, SysUtils,
  HttpFile in 'HttpFile.pas';

{$R *.RES}

var
   http: THttpFile;

begin
  if ParamCount() < 2 then
     MessageBox(GetForegroundWindow(),
                'DescargaHTTP'#10#13+
                'Junio/2003 - JM - www.jm.here.ws'#10#13+
                'Para el nº 15 de la revista Síntesis (www.grupoalbor.com)'#10#13#10#13+
                'Uso:'#10#13+
                '     DescargaHttp.exe url destino [progreso [cerrar]]'#10#13#10#13+
                ' · url: la dirección del recurso a descargar.'#10#13+
                ' · destino: la carpeta donde se dejará el recurso descargado.'#10#13+
                ' · progreso: indica si se mostrará la ventana de progreso.'#10#13+
                ' · cerrar: indica si aparacerá marcada la casilla "Cerrar diálogo".'#10#13#10#13+
                'Ejemplos:'#10#13+
                '  · DescargaHttp.exe www.grupoalbor.com/index.html c:\ s s'#10#13+
                '  · DescargaHttp.exe http://jm.here.ws/index.html c:\fich.htm',
                'DescargaHttp', MB_ICONINFORMATION)
  else
  begin
     http := THttpFile.Create(nil);
     try
        // traspasar parámetros
        http.URL     := ParamStr(1);
        http.Destino := ParamStr(2);
        if ParamCount > 2 then
        begin
           http.VerProgreso := (ParamStr(3) = 's') or (ParamStr(3) = 'S');

           if ParamCount > 3 then
              http.CerrarAlTerminar := (ParamStr(4) = 's') or (ParamStr(4) = 'S');
        end;

        // evento

        // descargar
        http.Download;

     finally
        http.Free;
     end;
//     Application.Run;
  end;
end.
