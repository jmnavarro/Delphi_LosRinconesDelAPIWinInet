//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: HttpFile.pas
//
// Propósito:
//    Implementa una clase que representa un archivo remoto que puede ser descargado a través
//    del protocolo HTTP.
//    La descarga se hace a través de un hilo de tipo THiloDescargaHTTP y opcionalmente puede
//    mostrar la ventana de diálogo definida en la clase TProgresoFrm.
//    Además, esta clase hereda de TComponent, por lo que puede registrarse y utillizarse
//    como otro componente más en la paleta de componentes.
//    El componente publica las siguiente propiedades:
//        · URL: la dirección del recurso a descargar
//        · Destino: Carpeta y/o archivo donde se almacenará la información descargada.
//        · VerProgreso: indica si se mostrará la ventana de progreso o no.
//        · CerrarAlTerminar: en caso de mostrarse el progreso, indica si aparecerá marcado
//          por defecto el check "Cerrar el diálogo al terminar la descarga".
//
// Autor:          JM - http://www.lawebdejm.com
// Observaciones:  Unidad creada en Delphi 5
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
// Modificaciones:
//	  JM 		01/06/2003	 Versión inicial
//	  JM 		11/07/2003	 Corregido un error pasando el nombre del recurso al diálogo de progreso.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit HttpFile;

interface

uses classes, HiloDescargaHTTP, ProgresoForm, windows;

type

   TAutor = type string;

   THttpFile = class(TComponent)
   private
      FURL: string;
      FDestino: string;
      FVerProgreso: boolean;
      FCerrarAlTerminar: boolean;

      FHilo: THiloDescarga;
      FDlg: TProgresoFrm;

      // eventos del componente
      FOnEstado:   TOnEstado;
      FOnProgreso: TOnProgreso;

      FAutor: TAutor;
      
      procedure SetURL(value: string);
      procedure SetAutor(value: TAutor);

      function GetDefaultFilename: string;

      // eventos del hilo
      procedure InternalOnEstado(tipo: TTipoEstado; msg: string; data: DWORD; var cancel: boolean);
      procedure InternalOnProgreso(BytesActual, BytesTotal: DWORD; var cancel: boolean);
      procedure InternalOnTerminate(Sender: TObject);

   public
      constructor Create(AOwner: TComponent); override;

      function Download: integer;

   published
      property URL: string read FURL write SetURL;
      property Destino: string read FDestino write FDestino;
      property VerProgreso: boolean read FVerProgreso write FVerProgreso default true;
      property CerrarAlTerminar: boolean read FCerrarAlTerminar write FCerrarAlTerminar default false;
      property Autor: TAutor read FAutor write SetAutor;

      // eventos para el IDE
      property OnEstado:   TOnEstado   read FOnEstado   write FOnEstado;
      property OnProgreso: TOnProgreso read FOnProgreso write FOnProgreso;
   end;

procedure Register;


implementation

uses SysUtils, wininet, HttpApp, DsgnIntf;

const
   TITLE_AUTOR = 'HttpFile - JM - www.jm.here.ws';
   MSG_AUTOR = 'HttpFile'#10#13#10#13'JM - www.jm.here.ws'#10#13#10#13+
               'El componente  HttpFile implementa un sistema para descargar archivos de internet utilizando el API Wininet y el protocolo HTTP.'#10#13+
               'Permite mostrar una ventana de progreso que imita la que utiliza Internet Explorer para las descargas de archivos.'#10#13+
               'El componente ha sido desarrollado para el número 15 de la revista Síntesis, publicada por el Grupo Albor (www.grupoalbor.com)'#10#13+
               'Para más información puedes dirigirte a la página web del autor (www.jm.here.ws) o a la del Grupo Albor.';

//
// Esta clase se utiliza para mostrar el mensaje informativo de la propiedad "Autor".
//
type
  TAutorProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  function TAutorProperty.GetAttributes: TPropertyAttributes;
  begin
     result := inherited GetAttributes;
     Include(result, paDialog);
  end;

  procedure TAutorProperty.Edit;
  begin
     MessageBox(GetForegroundWindow(), MSG_AUTOR, 'Autor de THttpFile', MB_ICONINFORMATION);
  end;



procedure Register;
begin
   RegisterPropertyEditor(TypeInfo(TAutor), THttpFile, 'Autor', TAutorProperty);
   RegisterComponents('JM', [THttpFile]);
end;



constructor THttpFile.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);

   FAutor := TITLE_AUTOR;
   FVerProgreso := true;
end;


function THttpFile.Download: integer;
var
   dest: string;
begin
   if FUrl = '' then
      raise Exception.Create('Debe asignarse una dirección a la propiedad "URL".');

   if FDestino = '' then
      raise Exception.Create('Debe asignarse una valor a la propiedad "Destino".');

   // se utiliza el valor por defecto
   dest := FDestino;
   if ExtractFileName(dest) = '' then
      dest := IncludeTrailingBackSlash(dest) + GetDefaultFilename();

   FHilo := THiloDescarga.Create(FURL, dest);

   FHilo.FreeOnTerminate := false;

   FHilo.OnTerminate := InternalOnTerminate;
   FHilo.OnEstado    := InternalOnEstado;
   FHilo.OnProgreso  := InternalOnProgreso;

   if FVerProgreso then
   begin
      FDlg := TProgresoFrm.Create(FHilo);

      FDlg.URL        := FUrl;
      FDlg.Carpeta    := ExtractFilePath(dest);
      FDlg.Archivo    := GetDefaultFilename();
      FDlg.Cerrar     := FCerrarAlTerminar;
   end;

   // aquí comienza la descarga
   FHilo.Resume();

   if FVerProgreso then
   begin
      FDlg.ShowModal();

      FDlg.Free;
      FDlg := nil;
   end
   else
      FHilo.WaitFor();  // esta función no retorna hasta que se haya terminado el hilo.

   result := FHilo.ReturnValue;

   FHilo.Free;
   FHilo := nil;
end;


procedure THttpFile.SetURL(value: string);
begin
   if (Pos('http://', value) <> 1) and (Pos('https://', value) <> 1) then
      value := 'http://' + value;

   if value <> FUrl then
      FUrl := value;
end;

procedure THttpFile.SetAutor(value: TAutor);
begin
   FAutor := TITLE_AUTOR;
end;


function THttpFile.GetDefaultFilename: string;
var
   comp: URL_COMPONENTS;
   url: array[0..256] of char;
begin
   ZeroMemory(@comp, sizeof(URL_COMPONENTS));
   comp.dwStructSize := sizeof(URL_COMPONENTS);

   comp.dwUrlPathLength := 255;
   comp.lpszUrlPath     := url;

   InternetCrackUrl(PChar(FUrl), Length(FUrl), 0, comp);

   result := ExtractFileName(UnixPathToDosPath(url));
end;

//
// Eventos internos que llaman a los eventos de usuario OnXXX
//
procedure THttpFile.InternalOnEstado(tipo: TTipoEstado; msg: string; data: DWORD; var cancel: boolean);
begin
   if Assigned(FDlg) then
      case tipo of
         tsContentLength:
            FDlg.BytesTotal := data;

         tsErrorConnectionAborted:
            FDlg.ErrorDownload(msg);

         tsErrorInternetOpen, tsErrorInternetOpenUrl, tsErrorInternetReadFile:
            FDlg.ErrorDownload('Se ha producido un error en la descarga.');

         tsErrorNoMoreFiles:
            FDlg.ErrorDownload('No se ha encontrado el archivo solicitado.');

         tsErrorCreateFile, tsErrorCreateFileMapping, tsErrorMapViewOfFile:
            FDlg.ErrorDownload('Error almacenando el archivo en disco.');
      end;

   if Assigned(FOnEstado) then
      FOnEstado(tipo, msg, data, cancel);
end;


procedure THttpFile.InternalOnProgreso(BytesActual, BytesTotal: DWORD; var cancel: boolean);
begin
   if Assigned(FDlg) then
      FDlg.BytesActual := BytesActual;

   if Assigned(FOnProgreso) then
      FOnProgreso(BytesActual, BytesTotal, cancel);
end;


procedure THttpFile.InternalOnTerminate(Sender: TObject);
begin
   if Assigned(FDlg) then
      FDlg.EndDownload();
end;


end.
