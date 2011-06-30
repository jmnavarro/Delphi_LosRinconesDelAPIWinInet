//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: HiloDescarga.pas
//
// Propósito:
//    Implementa un descendiente de TThread que permite descargar un recurso de internet,
//    utilizando el método directo de Wininet.
//
// Autor:          José Manuel Navarro - http://www.lawebdejm.com
// Observaciones:  Unidad creada en Delphi 5
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
// Modificaciones:
//	  JM 		01/06/2003		Versión inicial
//	  JM		11/07/2003		Corregido un error al acceder a un host o recurso inexistente.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit HiloDescargaHTTP;

interface

uses classes, windows;


type
   //
   // tipos de estado para el evento OnEstado.
   //
   TTipoEstado = (tsErrorInternetOpen,     tsInternetOpen,
                  tsErrorInternetOpenUrl,  tsInternetOpenUrl,
                  tsErrorInternetReadFile, tsInternetReadFile,
                  tsErrorHttpQueryInfo,    tsErrorNoMoreFiles,       tsContentLength,
                  tsErrorCreateFile,       tsErrorCreateFileMapping, tsErrorMapViewOfFile,
                  tsErrorConnectionAborted);

   //
   // Eventos que genera el hilo
   //
   TOnEstado   = procedure (tipo: TTipoEstado; msg: string; data: DWORD; var cancel: boolean) of object;
   TOnProgreso = procedure (BytesActual, BytesTotal: DWORD; var cancel: boolean) of object;

   //
   // Clase THiloDescarga
   //
   // Su uso es sencillo, se crea como cualquier otro descendiente de TThread, y se asignan
   // los eventos que queramos recibir:
   //    OnEstado: se envían mensajes por cada operación realizada, y cada error producido
   //    OnProgreso: se lanza cada vez que se descarga del servidor.
   // Después se utiliza como cualquier otro TThread, llamando al método Resume para comenzar
   // la ejecución
   THiloDescarga = class(TThread)
   private
      FURL:      string;
      FDestino:  string;

      // situación actual de la descarga
      FBytesTotal: DWORD;
      FBytesActual: DWORD;

      // eventos que soporta el hilo
      FOnEstado:   TOnEstado;
      FOnProgreso: TOnProgreso;

      // variable auxiliares para pasar parámetros a las funciones CallXXX
      TmpTipo   : TTipoEstado;
      TmpData   : DWORD;
      TmpMsg    : string;
      TmpCancel : boolean;

      // funciones para llamar a los eventos con Synchronize
      procedure CallOnEstado;
      procedure CallOnProgreso;

   protected
      function SendEstado(tipo: TTipoEstado; data: DWORD): boolean;
      function SendProgreso: boolean;

      function Descargar(var data: Pointer): integer;
      function Guardar(const data: Pointer; len: DWORD): integer; virtual;

      procedure Execute; override;

   public
      constructor Create(AURL, ADestino: string);

      property URL:     string read FURL     write FUrl;
      property Destino: string read FDestino write FDestino;

      property OnEstado:   TOnEstado   read FOnEstado   write FOnEstado;
      property OnProgreso: TOnProgreso read FOnProgreso write FOnProgreso;

      property ReturnValue; // publicar propiedad
   end;


implementation


uses wininet, SysUtils,

forms;


constructor THiloDescarga.Create(AURL, ADestino: string);
begin
   inherited Create(true);

   FURL     := AURL;
   FDestino := ADestino;
end;


//
// Método principal del hilo.
// Descarga el recurso y lo guarda en disco
//
procedure THiloDescarga.Execute;
var
   data: Pointer;
   len_data: integer;
begin
   len_data := Descargar(data);
   if len_data <= 0 then
      ReturnValue := len_data
   else
   begin
      ReturnValue := self.Guardar(data, len_data);

      if (data <> nil) then
         FreeMem(data, len_data);
   end;
end;


//
// Descarga de internet y lo almacena el buffer de parámetro, reservando espacio para él.
// Pasos:
//      1.- Abrir el API Wininet con InternetOpen
//      2.- Abrir el recurso con InternetOpenUrl
//      3.- Consultar la cabecera ContentLength para averiguar el tamaño del recurso
//      4.- Ir leyendo el recurso con InternetReadFile y almacenarlo en memoria
// Retorna
//      0 cancelado,
//    < 0 error
//    > 0 número de bytes del buffer (a liberar por el que llame a esta función)
//
function THiloDescarga.Descargar(var data: Pointer): integer;
var
   hInet: HINTERNET;
   hUrl:  HINTERNET;

   len:    DWORD;
   indice: DWORD;
   dummy:  DWORD;

   buff_lectura: Pointer;
   disponible:   DWORD;

   data_tmp:  Pointer;
   len_data:  DWORD;
   size_data: DWORD;

   function SalirConError(code: integer): integer;
   begin
      if (hInet <> nil) then InternetCloseHandle(hInet);
      if (hUrl  <> nil) then InternetCloseHandle(hUrl);

      if data <> nil then
      begin
         FreeMem(data, size_data);
         data := nil;
      end;

      result := code;
   end;

   function AmpliarBuffer(var buffer: Pointer; LenActual, LenMinima, LenDatos: DWORD): DWORD;
   var
      new_len: DWORD;
      buff_tmp: Pointer;
   begin
      // Esta función amplía el buffer hasta que quepan "LenMinima" bytes.
      // Además copia "LenDatos" bytes del buffer original al nuevo buffer.
      // Para ello se va duplicando el tamaño del buffer hasta llegar a "LenMinima"
      // La razón por la que se duplica el tamaño del buffer, en vez de ampliar
      // hasta el tamaño exacto, la expliqué durante el artículo
      // sobre los montones, que podéis consultar en http://www.lawebdejm.com/?id=21130
      // La función retorna el nuevo tamaño del buffer.

      new_len := LenActual;
      while ( new_len < LenMinima ) do
         new_len := new_len * 2;

      // Una vez que sabemos el tamaño al que tenemos que ampliar, creamos un nuevo
      // buffer de ese tamaño y traspasamos los datos.
      if new_len <> LenActual then
      begin
         // creo un buffer auxiliar donde copio el contenido
         GetMem(buff_tmp, new_len);

         if ( LenDatos > 0 ) then
            CopyMemory(buff_tmp, buffer, LenDatos);

         FreeMem(buffer, LenActual); // elimino el buffer actual (que se ha quedado demasiado pequeño)
         buffer := buff_tmp;         // paso a utilizar el nuevo buffer, que es el doble que el anterior
      end;
      result := new_len;
   end;

begin
   hUrl := nil;
   data := nil;

   // Paso 1
   hInet := InternetOpen('Descarga - Delphi',           // el user-agent
                          INTERNET_OPEN_TYPE_PRECONFIG, // configuración por defecto
                          nil, nil,                     // sin proxy
                          0 );                          // sin opciones

   if ( hInet = nil ) then
   begin
      SendEstado(tsErrorInternetOpen, GetLastError());
      result := SalirConError(-1);
      exit;
   end
   else
      SendEstado(tsInternetOpen, DWORD(hInet));

   // Paso 2
   hURL := InternetOpenUrl(hInet,  // el descriptor del api
                           PChar(FUrl), nil, 0,
                           INTERNET_FLAG_RELOAD, // opciones configuradas
                           0 );

   if self.Terminated then
   begin
      result := SalirConError(0);
      exit;
   end
   else if ( hURL = nil ) then
   begin
      SendEstado(tsErrorInternetOpenUrl, GetLastError());
      result := SalirConError(-2);
      exit;
   end
   else
   begin
		len    := sizeof(indice);
		indice := 0;
      dummy  := 0;
 	   HttpQueryInfo(hUrl, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @indice, len, dummy);

		case indice of

      	HTTP_STATUS_OK:
		      SendEstado(tsInternetOpenUrl, DWORD(hUrl));

      	HTTP_STATUS_NOT_FOUND:
         begin
		      SendEstado(tsErrorNoMoreFiles, DWORD(hUrl));
	         result := SalirConError(-3);
	         exit;
         end;

	      else
	      begin
		      SendEstado(tsErrorInternetOpenUrl, indice);
	         result := SalirConError(-3);
	         exit;
	      end;
      end;

   end;

   // Paso 3
   indice := 0;
   len := sizeof(DWORD);
   FBytesActual := 0;

   if ( not HttpQueryInfo(hUrl, HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER,
                          @FBytesTotal, len, indice) ) then
   begin
      SendEstado(tsErrorHttpQueryInfo, GetLastError());
      FBytesTotal := 0;

      size_data := 512; // comenzamos con un buffer de 512 bytes que irá creciendo
   end
   else
   begin
      if ( not SendEstado(tsContentLength, FBytesTotal) ) then
      begin
         result := SalirConError(0);
         exit;
      end;

      // si conocemos el tamaño total, reservamos los bufferes directamente
      size_data := FBytesTotal;
   end;

   // Paso 4
   buff_lectura := nil;
   disponible   := 0;

   GetMem(data, size_data);
   len_data := 0;

   len := 0;

   repeat
      if self.Terminated then
      begin
         result := SalirConError(0);
         exit;
      end;

      //
      // Consultar los datos que están disponibles en el servidor
      //
      if ( not InternetQueryDataAvailable( hUrl, disponible, 0, 0) ) then
      begin
         case GetLastError() of
           ERROR_NO_MORE_FILES:
           begin
              if not SendEstado(tsErrorNoMoreFiles, ERROR_NO_MORE_FILES) then
                 result := SalirConError(0)
              else
                 result := SalirConError(-4);
           end;

           ERROR_INTERNET_CONNECTION_RESET,
           ERROR_INTERNET_CONNECTION_ABORTED:
           begin
              if not SendEstado(tsErrorConnectionAborted, GetLastError()) then
                 result := SalirConError(0)
              else
                 result := SalirConError(-5);
           end;

           else
              result := SalirConError(-6);
         end;

         exit;
      end;

      if ( 0 = disponible ) then
      begin
         len := 0;
         continue;
      end
      else
         GetMem(buff_lectura, disponible);

      //
      // Leer el número de bytes disponibles
      //
      if ( not InternetReadFile( hUrl, buff_lectura, disponible, len) ) then
      begin
         if not SendEstado(tsErrorInternetReadFile, 0) then
            result := SalirConError(0)
         else
            result := SalirConError(-7);

         FreeMem(buff_lectura, disponible);
         exit;
      end
      else if ( len > 0 ) then
      begin
         // ampliar el buffer con la función auxiliar
         size_data := AmpliarBuffer(data, size_data, len_data + len, len_data);

         // copiar los datos leídos al nuevo buffer general
         data_tmp := data;
         Inc(PByte(data_tmp), len_data);
         CopyMemory(data_tmp, buff_lectura, len);

         Inc(len_data, len);

         // se notifica del tamaño descargado
         FBytesActual := len_data;

         if ( not SendProgreso() ) then
         begin
            result := SalirConError(0);
            exit;
         end;
      end;

   until ( len = 0 );

   if ( buff_lectura <> nil ) then
      FreeMem(buff_lectura, disponible);

   result := size_data;
end;


//
// Guarda una zona de memoria en el disco, utilizando la técnica de archivos proyectados en
// memoria. Para más información sobre cómo utilizar esta técnica podéis consultar el artículo
// publicado en http://www.lawebdejm.com/?id=21140
//
function THiloDescarga.Guardar(const data: Pointer; len: DWORD): integer;
var
   hFile: THandle;
   hFileMap: THandle;
   vista: Pointer;
begin
   hFile := CreateFile(PChar(Destino),       // los datos los guardamos en el destino
                       GENERIC_READ or GENERIC_WRITE, 0, nil, // abrimos de lectura/escritura
                       CREATE_ALWAYS,                         // creamos un archivo si no existe
                       FILE_ATTRIBUTE_NORMAL, 0);

   if ( INVALID_HANDLE_VALUE = hFile ) then
   begin
      SendEstado(tsErrorCreateFile, 0);
      result := -100;
   end
   else
   begin
      hFileMap := CreateFileMapping(hFile,                // creamos la proyección
                                    nil, PAGE_READWRITE,  // de lectura/escritura
                                    0, len,               // del tamaño del buffer
                                    nil);                 // sin nombre

      if ( hFileMap = 0 ) then
      begin
         SendEstado(tsErrorCreateFileMapping, 0);
         result := -200;
      end
      else
      begin
         vista := MapViewOfFile(hFileMap,       // creamos la vista sobre la proyección
                                FILE_MAP_WRITE, // de lectura/escritura
                                 0, 0, 0);
         if ( vista = nil ) then
         begin
            SendEstado(tsErrorMapViewOfFile, 0);
            result := -300;
         end
         else
         begin
            // como ya podemos acceder al archivo como si fuera un bloque de memoria,
            // copiamos los caracteres en él,utilizando la función del API Win32 CopyMemory
            CopyMemory(vista, data, len);

            FlushViewOfFile(vista, len); // nos aseguramos que todo queda bien guardado

            UnmapViewOfFile(vista); // y cerramos todos los descriptores abiertos

            result := 0;
         end;

         CloseHandle(hFileMap);
      end;
      CloseHandle(hFile);
   end;
end;


//
// Métodos para simplificar las llamadas a los eventos
//
function THiloDescarga.SendEstado(tipo: TTipoEstado; data: DWORD): boolean;
const
   MENSAJES_ESTADO: array[TTipoEstado] of PChar =
   (
      'Error InternetOpen - %d',                          // tsErrorInternetOpen
      'Instancia a internet abierta con éxito.',          // tsInternetOpen
      'Error InternetOpenUrl - %d',                       // tsErrorInternetOpenUrl
      'Recurso remoto abierto con éxito.',                // tsInternetOpenUrl
      'Error InternetReadFile - %d',                      // tsErrorInternetReadFile
      'Leídos %u bytes del servidor.',                    // tsInternetReadFile
      'No es posible recuperar el tamaño del archivo.',   // tsErrorHttpQueryInfo
      'El recurso no existe',                             // tsErrorNoMoreFiles
      'El archivo ocupa %u bytes.',                       // tsContentLength
      'No se ha podido crear el archivo destino.',        // tsErrorCreateFile
      'No se ha podido crear la proyección de archivo.',  // tsErrorCreateFileMapping,
      'No se ha podido crear la vista sobre la proyección de archivo.', //tsErrorMapViewOfFile
      'Se ha perdido la conexión con el servidor.'        //tsErrorConnectionAborted
   );
begin
   result := true;

   if Assigned(FOnEstado) then
   begin
      case tipo of
         tsInternetReadFile, tsContentLength:
            SendProgreso();
      end;

      TmpMsg    := Format(MENSAJES_ESTADO[tipo], [data]);
      TmpTipo   := tipo;
      TmpData   := data;
      TmpCancel := false;

      Synchronize(CallOnEstado);

      result := not TmpCancel;
   end;
end;


function THiloDescarga.SendProgreso: boolean;
begin
   TmpData   := FBytesActual;
   TmpCancel := false;

   Synchronize(CallOnProgreso);
   result := not TmpCancel;
end;


//
// Métodos auxiliares para llamar a los eventos con Synchronize
//
procedure THiloDescarga.CallOnEstado;
begin
   if Assigned(FOnEstado) then
      FOnEstado(TmpTipo, TmpMsg, TmpData, TmpCancel);
end;

procedure THiloDescarga.CallOnProgreso;
begin
   if Assigned(FOnProgreso) then
      FOnProgreso(TmpData, FBytesTotal, TmpCancel);
end;



end.
