//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: ProgresoForm.pas
//
// Propósito:
//    Diseñar un formulario con la misma apariencia que el que muestra Internet Explorer 5
//    durante la descarga.
//    Para crear el formulario es necesario pasar el hilo que realizará la descarga como
//    parámetro del create.
//
// Autor:          José Manuel Navarro - http://www.lawebdejm.com
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 15 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
// Modificaciones:
//    JM      01/06/2006      Versión inicial
//    JM      11/06/2006      Al llamarse al método ErrorDlg desde la clase THttpFile (cuando se
//                            producía un error en la descarga), se producía un error de sincro-
//                            nización con los mensajes que estaban en la cola. Se corrige ejecu-
//                            tanto un application.ProcessMessages() antes de cerrar el diálogo de
//                            progreso.
//                            Se añade también el método CrackUrl para descomponer la URL pasada
//                            en sus distintos componentes (host y recurso).
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit ProgresoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;


type
  // estados posibles del formulario
  TEstadoDescarga = (edDescargando, edTerminado, edError, edAbriendo, edCerrando, edCancelado);

  TProgresoFrm = class(TForm)
    avi: TAnimate;
    b_abrir: TButton;
    l_guardando: TLabel;
    l_url: TLabel;
    pb_progreso: TProgressBar;
    l_progreso: TLabel;
    l_tasa: TLabel;
    cb_cerrar: TCheckBox;
    b_abrirCarpeta: TButton;
    b_cancelar: TButton;
    i_completo: TImage;
    l_completa: TLabel;
    l_tiempo: TLabel;
    l_descargar: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure b_cancelarClick(Sender: TObject);
    procedure AbrirArchivo(Sender: TObject);
    procedure AbrirCarpeta(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    l_carpeta: TLabel; // componente creado en ejecución

    FEstado:   TEstadoDescarga;

    FCarpeta: 	string;
    FFileName: string;

    FURL:     string;
    FHost:    string;
    FRecurso: string;

    FHilo: TThread;

    FTickInicial:  DWORD;
    FTickActual:   DWORD;
    FTickAnterior: DWORD;

    FTasaTransferencia: DWORD;  // en KB/Seg
    FTiempoEstimado:    DWORD;  // en msegs
    FPorcentaje:        single; // x,y%

    FBytesActual: DWORD;
    FBytesTotal: DWORD;
    FPasos: integer;

    procedure CargarAVI(id: integer);

    procedure CrackHost(var host, recurso: string);

    procedure SetBytesTotal(value: DWORD);
    procedure SetBytesActual(value: DWORD);

    procedure SetMensajesProgreso(BytesActual, BytesTotal: DWORD);

    procedure SetUrl(value: string);
    procedure SetCarpeta(value: string);
    procedure SetFilename(value: string);
    procedure SetEstado(value: TEstadoDescarga);
    procedure SetCerrar(value: boolean);

    function CalcularEstadisticas(BytesActual, BytesTotal: DWORD): boolean;
    function CalcularTasaTransferencia(BytesTotal, MSegTotal: DWORD): DWORD;
    function CalcularTiempoEstimado(BytesActual, BytesTotal: integer): integer;

  protected
    property Estado: TEstadoDescarga read FEstado write SetEstado;

  public
    constructor Create(hilo: TThread); reintroduce;

    procedure EndDownload;
    procedure CancelDownload;
    procedure ErrorDownload(msg: string);

    class function GetBytesStr(bytes: DWORD): string;
    class function GetTimeStr(msegs: DWORD): string;

    property BytesTotal:  DWORD read FBytesTotal  write SetBytesTotal;
    property BytesActual: DWORD read FBytesActual write SetBytesActual;

    property URL:         string  read FURL           write SetURL;
    property Carpeta:     string  read FCarpeta       write SetCarpeta;
    property Archivo:     string  read FFilename      write SetFilename;
    property Cerrar:      boolean                     write SetCerrar;
  end;

implementation

{$R *.DFM}

// Se incluye el recurso AVI situado en el archivo "animacion.res". Este archivo se ha
// creado compilando el recurso fuente de "animacion.rc", ejecutando el comando:
//    C:\>Delphi5\Bin\brc32.exe -foanimacion.res -v animacion.rc

{$R animacion.res}

uses ShellAPI, Wininet, HttpApp;

//
// Creo una especialización de TLabel que permita mostrar rutas de archivo, insertando
// los puntos suspensivos si no caben en su area cliente.
//
type
   TPathLabel = class(TLabel)
   protected
      procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
   end;

   procedure TPathLabel.DoDrawText(var Rect: TRect; Flags: Longint);
   var
      text: string;
   begin
      // he copiado el código de la VCL, cambiando la llamada a DrawText por DrawTextEX y
      // añadiendo la bandera DT_PATH_ELLIPSIS
      Text := GetLabelText();

      if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
         (Text[1] = '&') and (Text[2] = #0)) then
      begin
         Text := Text + ' ';
      end;

      if not ShowAccelChar then
         Flags := Flags or DT_NOPREFIX;

      Flags := DrawTextBiDiModeFlags(Flags);
      Flags := Flags or DT_PATH_ELLIPSIS;

      Canvas.Font := Font;

      if not Enabled then
      begin
         OffsetRect(Rect, 1, 1);
         Canvas.Font.Color := clBtnHighlight;
         DrawTextEx(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags, nil);
         OffsetRect(Rect, -1, -1);
         Canvas.Font.Color := clBtnShadow;
      end;

      DrawTextEx(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags, nil);
   end;
//---------------------------------------------------------------------------------


const
   AVI_HTTPDOWNLOAD = 1000;    // id del recurso del video AVI

constructor TProgresoFrm.Create(hilo: TThread);
begin
  inherited Create(nil);
  FHilo := hilo;
end;


procedure TProgresoFrm.FormCreate(Sender: TObject);
begin
   FEstado := edAbriendo;
   Estado  := edDescargando;

   //
   // No utilizo un TLabel normal porque no dibuja las rutas abreviadas, de decir, si
   // establezco una cadena más larga que el ancho del label, necesito mostrarla con
   // puntos suspensivos en el medio:
   //    C:\Ruta con nombre largo\...\archivo.ext
   // Tengo que crear un TPathLabel en tiempo de ejecución, o bien crear un componente
   // TPathLabel y registrarlo.
   //
   l_carpeta := TPathLabel.Create(self);
   l_carpeta.SetBounds(l_progreso.left, l_descargar.top, l_progreso.width, l_progreso.height);
   l_carpeta.AutoSize := false;
   l_carpeta.visible  := false;
   l_carpeta.Parent   := self;
end;


procedure TProgresoFrm.CargarAVI(id: integer);
begin
   avi.ResId  := id;
   avi.Show;
   avi.Active := true;
end;


//
// Trocea la URL para obtener el nombre de host.
//
procedure TProgresoFrm.CrackHost(var host, recurso: string);
var
   comp: URL_COMPONENTS;
   host_name: array[0..256] of char;
   rec_name:  array[0..256] of char;
begin
   ZeroMemory(@comp, sizeof(URL_COMPONENTS));
   comp.dwStructSize := sizeof(URL_COMPONENTS);

   comp.dwHostNameLength := 255;
   comp.lpszHostName     := host_name;
   comp.dwUrlPathLength  := 255;
   comp.lpszUrlPath      := rec_name;

   InternetCrackUrl(PChar(FUrl), Length(FUrl), 0, comp);

   host    := host_name;
   recurso := ExtractFileName(UnixPathToDosPath(rec_name));
end;


procedure TProgresoFrm.SetBytesTotal(value: DWORD);
begin
   if FBytesTotal <> value then
   begin
      FBytesTotal := value;
      
      pb_progreso.Max := FBytesTotal div 1024;
      pb_progreso.visible := true;
      l_carpeta.visible := true;
   end;
end;

procedure TProgresoFrm.SetBytesActual(value: DWORD);
const
   FRECUENCIA_ACTUALIZACION = 750;
var
   MostrarEstadisticas: boolean;
begin
   if (value > 0) then
   begin
      FBytesActual := value;

      FTickActual := GetTickCount();
      if FPasos <> -1 then Inc(FPasos);

      if FTickInicial = 0 then
      begin
         FTickInicial := FTickActual;
         l_guardando.Caption := 'Guardando:';
      end;

      MostrarEstadisticas := CalcularEstadisticas(FBytesActual, FBytesTotal);

      // solo se actualizan los mensajes cada "FRECUENCIA_ACTUALIZACION" milisegundos
      if (((FTickActual - FTickAnterior) >= FRECUENCIA_ACTUALIZACION) or (FPasos > 2)) and
         MostrarEstadisticas then
      begin
         FPasos := -1;
         SetMensajesProgreso(FBytesActual, FBytesTotal);
         FTickAnterior := FTickActual;
      end;
   end;
end;


//
// Muestra en el interfaz los mesajes de progreso (%, tiempo estimado, tasa de descarga)
//
procedure TProgresoFrm.SetMensajesProgreso(BytesActual, BytesTotal: DWORD);
var
   titulo, progreso: string;
begin
   if BytesTotal > 0 then
   begin
      titulo   := Format('Completados %u%% de %s', [Round(FPorcentaje), Archivo]);
      progreso := Format('%s (%s de %s copiados)',
                         [GetTimeStr(FTiempoEstimado),
                         GetBytesStr(BytesActual),
                         GetBytesStr(BytesTotal)]);

      // se actualiza la barra de progreso, en KBytes
      pb_progreso.position := FBytesActual div 1024;
   end
   else
   begin
      titulo   := Format('Copiados %s de %s', [GetBytesStr(BytesActual), Archivo]);
      progreso := Format('Desconocido (Abierto hasta el momento: %s)',
                         [GetBytesStr(BytesActual)]);
   end;

   self.caption       := titulo;
   l_progreso.caption := progreso;

   l_tasa.caption := Format('%d KB/Seg', [FTasaTransferencia]);
end;



procedure TProgresoFrm.SetUrl(value: string);
begin
   if FUrl <> value then
   begin
      FUrl := value;
      CrackHost(FHost, FRecurso);

      l_url.caption     := Format('%s de %s', [FRecurso, FHost]);
      l_carpeta.caption := Format('%s%s',     [FCarpeta, FFileName]);
   end;
end;

procedure TProgresoFrm.SetCarpeta(value: string);
begin
   if FCarpeta <> value then
   begin
      FCarpeta := IncludeTrailingBackSlash(value);

      l_carpeta.caption := Format('%s%s', [FCarpeta, FFileName]);
   end;
end;

procedure TProgresoFrm.SetFilename(value: string);
begin
   if FFilename <> value then
   begin
      FFileName := value;

      l_url.caption     := Format('%s de %s', [FRecurso, FHost]);
      l_carpeta.caption := Format('%s%s',     [FCarpeta, FFileName]);
   end;
end;


//
// La ventana tiene varios estados, algunos de ellos repercuten directamente en el interfaz a
// mostrar. Esta función cambia el interfaz dependiendo del estado.
//
procedure TProgresoFrm.SetEstado(value: TEstadoDescarga);
var
   msegs: DWORD;
begin
   if value <> FEstado then
   begin
      FEstado := value;

      case FEstado of

         edDescargando:
         begin
            CargarAVI(AVI_HTTPDOWNLOAD);

            i_completo.Hide();

            self.caption        := 'Descarga de archivos';
            //l_guardando.caption := 'Guardando:';
            l_tiempo.caption    := 'Tiempo estimado:';
            b_cancelar.caption  := 'Cancelar';

            b_abrir.enabled        := false;
            b_abrirCarpeta.enabled := false;
            b_cancelar.enabled     := true;
         end;

         edTerminado:
         begin
            FTickActual := GetTickCount();
            msegs := FTickActual - FTickInicial;
            if (msegs/1000) = 0 then
               msegs := 501;

            // terminar
            if FBytesTotal > 0 then
            begin
               BytesActual := FBytesTotal;
               ASSERT(FBytesTotal = FBytesActual);
               pb_progreso.Position := pb_progreso.Max;
            end;

            avi.Active := false;
            avi.Hide();

            i_completo.Show();
            l_completa.Show();

            self.caption        := 'Descarga completa';
            l_guardando.caption := 'Guardado:';
            l_tiempo.caption    := 'Descargado:';
            b_cancelar.caption  := 'Cerrar';
            l_tasa.caption      := Format('%d KB/Seg',
                                          [Round((FBytesActual/1024)/(msegs/1000))]);

            l_progreso.caption := Format('%s en %s',
                                          [GetBytesStr(FBytesActual),
                                          GetTimeStr(msegs)]);

            b_abrir.enabled        := true;
            b_abrirCarpeta.enabled := true;
            b_cancelar.enabled     := true;
         end;

         edCancelado:
         begin
            b_cancelar.enabled := false;
            b_cancelar.Repaint();
         end;

      end;
   end;
end;


procedure TProgresoFrm.SetCerrar(value: boolean);
begin
   if value <> cb_cerrar.checked then
      cb_cerrar.checked := value;
end;


//
// Calcula las estadísticas y las almacena en los atributos internos
// Retorna un valor booleano indicando si se han podido calcular todas las estadísticas
//
function TProgresoFrm.CalcularEstadisticas(BytesActual, BytesTotal: DWORD): boolean;
begin
   FTasaTransferencia := CalcularTasaTransferencia(BytesActual,
                                                   FTickActual - FTickInicial);
   if BytesTotal > 0 then
   begin
      FPorcentaje := (BytesActual / BytesTotal) * 100;
      FTiempoEstimado := CalcularTiempoEstimado(BytesActual, BytesTotal);
   end;

   result := (FTasaTransferencia <> DWORD(-1)) and
             ((FTiempoEstimado   <> DWORD(-1)) or (BytesTotal = 0));
end;

//
// auxiliar que calcula la tasa de transferencia, o -1 si no es posible calcular
//
function TProgresoFrm.CalcularTasaTransferencia(BytesTotal, MSegTotal: DWORD): DWORD;
begin
   // si no han pasado segundos de descarga, no podemos calcular la tasa
   if (MSegTotal / 1000) = 0 then
      result := DWORD(-1)
   else
      result := Round( (BytesTotal / 1024) / (MSegTotal / 1000) );
end;

//
// auxiliar que calcula el tiempo estimado, o -1 si no es posible calcular
//
function TProgresoFrm.CalcularTiempoEstimado(BytesActual, BytesTotal: integer): integer;
var
   TiempoActual: integer;
begin
   if (BytesTotal = 0) or (FTickActual = FTickInicial) or ((BytesActual div 1024) = 0) then
      result := -1
   else
   begin
      TiempoActual := FTickActual - FTickInicial;
      result := Round( (((BytesTotal / 1024)* TiempoActual) / (BytesActual div 1024)) - TiempoActual );
   end;
end;

//
// Método publico que se debe llamar cuando se termine la descarga (cuando termine el hilo)
//
procedure TProgresoFrm.EndDownload;
begin
   if FEstado <> edCancelado then
      if cb_cerrar.checked then
      begin
         FEstado := edCerrando;
         ModalResult := mrOK;
      end
      else
         Estado := edTerminado;
end;

//
// Método que lanza el evento de cancelación y cierra la ventana si la cancelación progresa
//
procedure TProgresoFrm.CancelDownload();
begin
   Estado := edCancelado;

   // terminamos el hilo y esperamos a que realmente se destruya.
   FHilo.Terminate();
   FHilo.WaitFor();

   ModalResult := mrAbort;
end;

procedure TProgresoFrm.ErrorDownload(msg: string);
begin
   MessageBox(handle, PChar(msg), 'Descarga abortada', MB_ICONERROR);
   Estado := edError;

	application.ProcessMessages();
   ModalResult := mrAbort;
end;


//
// Función auxiliar para retornar la descripción de un número de bytes dado.
//      p.e.  GetBytesStr(1500000) --> '1,43 MB'
//
class function TProgresoFrm.GetBytesStr(bytes: DWORD): string;
type
   TByteType = (btByte, btKByte, btMByte, btGByte);
const
   ByteValues: array[TByteType] of DWORD =
      (
         {byte}  1,
         {KByte} 1 * 1024,
         {MByte} 1 * 1024 * 1024,
         {GByte} 1 * 1024 * 1024
      );

   ByteNemonic: array[TByteType] of string[5] =
      (
         {byte}  'bytes',
         {KByte} 'KB',
         {MByte} 'MB',
         {GByte} 'GB'
      );
var
   tipo: TByteType;
begin
   if bytes >= 1000 then // mostrar como K }
      tipo := btKByte
   else                  // mostrar como bytes
      tipo := btByte;

   if bytes >= 1000 * 1024 then // mostrar como MB
      tipo := btMByte;

   if bytes >= 1000 * 1024 * 1024 then // mostrar como GB
      tipo := btGByte;

   result := Trim(Format('%6.3g %s', [bytes/ByteValues[tipo], ByteNemonic[tipo]]));
end;

//
// Función auxiliar para retornar la descripción de una cantidad de milisegundos
//      p.e.  GetTimeStr(30000)   --> '30 seg.'
//            GetTimeStr(100000)  --> '1 min. 40 seg.'
//            GetTimeStr(3900000) --> '1 hr. 5 min.'
//
class function TProgresoFrm.GetTimeStr(msegs: DWORD): string;
var
   segs: DWORD;
   mins: DWORD;
   horas: DWORD;
begin
   if msegs < 1000 then { considero un mínimo de un segundo }
      result := '1 seg.'
   else
   begin
      segs  := Round(msegs/1000);
      mins  := 0;
      horas := 0;

      if (segs >= 60) then { minutos }
      begin
         mins := segs div 60;
         segs := segs mod 60;
      end;

      if (mins >= 60) then { horas }
      begin
         horas := mins div 60;
         mins  := mins mod 60;
      end;

      if horas > 0 then
         result := Format('%d hr. %d min.', [horas, mins])
      else if mins > 0 then
         result := Format('%d min. %d seg.', [mins, segs])
      else
         result := Format('%d seg.', [segs]);

   end;
end;




procedure TProgresoFrm.b_cancelarClick(Sender: TObject);
begin
   case FEstado of
      edDescargando: CancelDownload();
      edTerminado:   ModalResult := mrOK;
   end;
end;

procedure TProgresoFrm.AbrirArchivo(Sender: TObject);
begin
   ShellExecute(handle, nil, PChar(FCarpeta + FFileName), nil, nil, SW_NORMAL);
   ModalResult := mrOK;
end;

procedure TProgresoFrm.AbrirCarpeta(Sender: TObject);
begin
   ShellExecute(handle, nil, PChar(FCarpeta), nil, nil, SW_NORMAL);
   ModalResult := mrOK;
end;

procedure TProgresoFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if (Estado = edDescargando) and (ModalResult <> mrNone) then
   begin
      CancelDownload();
      CanClose := (ModalResult <> mrNone);
   end;

	application.ProcessMessages();
end;


end.