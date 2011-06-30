//---------------------------------------------------------------------------------------------
//
// Archivo: HiloDescarga.pas
//
// Propósito:
//    Se trata de un descendiente de la clase THilo, que permite realizar la descarga de un
//    segmento de un recurso a través del API WinInet y el uso de la cabecera RANGE de HTTP.
//    Si se quieren recibir los eventos que la descarga de archivos genera, se debe implementar
//    un descendiente de esta clase, y sobrescribir los métodos virtuales "OnXXXXX". Esto se 
//    hace en la clase THiloDescargaEventos.
//
// Autor:          José Manuel Navarro - http://www.lawebdejm.com
// Fecha:          01/05/2004
// Observaciones:  Unidad creada en Delphi 5.
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//---------------------------------------------------------------------------------------------
unit HiloDescarga;

interface

uses Hilo, Windows, WinInet;

type
	THiloDescarga = class(THilo)
	private
		FURL:     string;
		FDestino: string;

		data: PByte;

		hFile: THandle;
		hMap:  THandle;

		function parseURLData(URL: string; var host: string; var recurso: string): boolean;
		function getSize(conexion: HINTERNET; recurso: string): DWORD;
		function getHeader(byteIni, byteFin: DWORD): string;

		function openInternet(var hInet: HINTERNET): boolean;
		function connectInternet(hInet: HINTERNET; var hConn: HINTERNET; var recurso: string): boolean;
		function sendRequest(hConn: HINTERNET; var hRecurso: HINTERNET; recurso: string; var size: DWORD; var byteIni: DWORD; var byteFin: DWORD): boolean;
		procedure downloadFile(hRecurso: HINTERNET; data: PByte; byteIni: DWORD; var sizeDescargado: DWORD);

		function openFile(filename: string; size: DWORD): PByte;
		procedure saveFile(var data: PByte);

	protected
		function funcionHilo: DWORD; override;

		//
		// eventos
		//
		function  onBeginDownload(var byteIni: DWORD; var byteFin: DWORD; size: DWORD): boolean; virtual;
		procedure onEndDownload(totalBytes: DWORD); virtual;
		function  onProcessDownload(currentBytes: DWORD): boolean; virtual;
		procedure onCancelDownload(currentByte: DWORD); virtual;

		property URL: string read FURL;
		property Destino: string read FDestino;

	public
		function descargar(url, destino: string): boolean; virtual;

	end;


implementation


uses SysUtils;


function THiloDescarga.parseURLData(URL: string; var host: string; var recurso: string): boolean;
const
	SIZE_HOST = 128;
	SIZE_RECURSO = 256;
var
	components: URL_COMPONENTS;
	buffHost: array[0..SIZE_HOST-1] of char;
	buffRecurso: array[0..SIZE_RECURSO-1] of char;
begin
	ZeroMemory(@buffHost, SIZE_HOST);
	ZeroMemory(@buffRecurso, SIZE_RECURSO);

	// Preparo la estructura URL_COMPONENTS para descomponer la URL
	ZeroMemory(@components, sizeof(URL_COMPONENTS));
	components.dwStructSize := sizeof(URL_COMPONENTS);

	components.dwHostNameLength := SIZE_HOST;
	components.lpszHostName     := buffHost;

	components.dwUrlPathLength  := SIZE_RECURSO;
	components.lpszUrlPath      := buffRecurso;

	result := InternetCrackUrl(PChar(URL), 0, 0, components);

	if result then
	begin
		host := buffHost;
		recurso := buffRecurso;
	end;
end;


function THiloDescarga.getSize(conexion: HINTERNET; recurso: string): DWORD;
var
	len, dummy: DWORD;
	hRecurso: HINTERNET;
begin
	result := 0;
	hRecurso := HttpOpenRequest(conexion, 'HEAD', PChar(recurso), nil, nil, nil, INTERNET_FLAG_RELOAD, 0);

	if hRecurso <> nil then
		if HttpSendRequest(hRecurso, nil, 0, nil, 0) then
		begin
			len := sizeof(result);
			dummy := 0;

			if not HttpQueryInfo(hRecurso, HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER, Pointer(@result), len, dummy) then
				result := 0;
		end;

	InternetCloseHandle(hRecurso);
end;


function THiloDescarga.getHeader(byteIni, byteFin: DWORD): string;
begin
	if (byteIni > 0) and (byteFin > 0) then
		result := Format('Range: bytes=%d-%d', [byteIni, byteFin])
	else if byteIni > 0 then
		result := Format('Range: bytes=%d-', [byteIni, byteFin])
	else
		result := '';
end;


function THiloDescarga.openFile(filename: string; size: DWORD): PByte;
begin
	result := nil;

	hFile := CreateFile(PChar(filename), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
	if hFile <> INVALID_HANDLE_VALUE then
	begin
		hMap := CreateFileMapping(hFile, nil, PAGE_READWRITE, 0, size, nil);
		if hMap = 0 then
			CloseHandle(hFile)
		else
			result := MapViewOfFile(hMap, FILE_MAP_WRITE, 0, 0, 0);
	end;
end;

procedure THiloDescarga.saveFile(var data: PByte);
begin
	FlushViewOfFile(data, 0);
	UnmapViewOfFile(data);
	data := nil;

	CloseHandle(hMap);
	CloseHandle(hFile);

	hMap := 0;
	hFile := 0;
end;


function THiloDescarga.funcionHilo: DWORD;
var
	hInet, hConn, hRecurso: HINTERNET;
	recurso: string;
	size, sizeDescargado, byteIni, byteFin: DWORD;

	procedure CloseHandles(error: boolean);
	begin
		if hRecurso <> nil then
			InternetCloseHandle(hRecurso);

		if hConn <> nil then
			InternetCloseHandle(hConn);

		if hInet <> nil then
			InternetCloseHandle(hInet);

		if error then
			onCancelDownload(0)
		else if Cancelado then
			onCancelDownload(byteIni + sizeDescargado)
		else
			onEndDownload(byteIni + sizeDescargado);
	end;

begin
	result := 0;
	hInet := nil;
	hConn := nil;
	hRecurso := nil;

	Cancelado := false;

	if not openInternet(hInet) then
	begin
		CloseHandles(true);
		exit;
	end;

	if not connectInternet(hInet, hConn, recurso) then
	begin
		CloseHandles(true);
		exit;
	end;

	if not sendRequest(hConn, hRecurso, recurso, size, byteIni, byteFin) then
	begin
		CloseHandles(true);
		exit;
	end;

	if FDestino[Length(FDestino)] <> '\' then
		FDestino := FDestino + '\';

	FDestino := FDestino + (StrRScan(PChar(recurso), '/')+1);
	data := openFile(FDestino, size);
	if data = nil then
	begin
		CloseHandles(true);
		exit;
	end;

	downloadFile(hRecurso, data, byteIni, sizeDescargado);

	saveFile(data);

	CloseHandles(false);
   
	result := 1;
end;


function THiloDescarga.openInternet(var hInet: HINTERNET): boolean;
begin
	hInet  := InternetOpen('Multi-Descarga', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
	result := (hInet <> nil);
end;


function THiloDescarga.connectInternet(hInet: HINTERNET; var hConn: HINTERNET; var recurso: string): boolean;
var
	host: string;
begin
	parseURLData(FURL, host, recurso);

	hConn := InternetConnect(hInet, PChar(host), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);

	result := (hConn <> nil);
end;


function THiloDescarga.sendRequest(hConn: HINTERNET; var hRecurso: HINTERNET; recurso: string; var size: DWORD; var byteIni: DWORD; var byteFin: DWORD): boolean;
var
	header: string;
begin
	result := false;
	hRecurso := HttpOpenRequest(hConn, 'GET', PChar(recurso), nil, nil, nil, INTERNET_FLAG_RELOAD, 0);

	size := getSize(hConn, recurso);
	if size = 0 then
		exit;

	byteIni := 0;
	byteFin := size;

	if not onBeginDownload(byteIni, byteFin, size) then
		exit;

	if (byteIni > 0) or (byteFin > size) then
	begin
		header := getHeader(byteIni, byteFin);
		if header <> '' then
			HttpAddRequestHeaders(hRecurso, PChar(header), Length(header), HTTP_ADDREQ_FLAG_ADD_IF_NEW);
	end;

	result := HttpSendRequest(hRecurso, nil, 0, nil, 0);
end;


procedure THiloDescarga.downloadFile(hRecurso: HINTERNET; data: PByte; byteIni: DWORD; var sizeDescargado: DWORD);
const
	CHUNK_SIZE = 4 * 1024;
var
	leido: DWORD;
	dataPtr: PByte;
	buffer: array[0..CHUNK_SIZE-1] of Byte;
begin
	dataPtr := data;
	Inc(dataPtr, byteIni);
	sizeDescargado := 0;

	repeat
		ZeroMemory(@buffer, sizeof(buffer));
		InternetReadFile(hRecurso, @buffer, sizeof(buffer), leido);
		if leido > 0 then
		begin

			CopyMemory(dataPtr, @buffer, leido);
			Inc(sizeDescargado, leido);
			Inc(dataPtr, leido);

			if not onProcessDownload(sizeDescargado + byteIni) then
				exit;
		end;
	until Cancelado or (leido = 0);

	if not Cancelado then
	begin
		dataPtr := data;
		Inc(dataPtr, sizeDescargado + byteIni);
		dataPtr^ := 0;
	end;
end;



//
// eventos
//
function  THiloDescarga.onBeginDownload(var byteIni: DWORD; var byteFin: DWORD; size: DWORD): boolean;
begin
	result := false;
end;

procedure THiloDescarga.onEndDownload(totalBytes: DWORD);
begin
end;

function  THiloDescarga.onProcessDownload(currentBytes: DWORD): boolean;
begin
	result := false;
end;

procedure THiloDescarga.onCancelDownload(currentByte: DWORD);
begin
end;


function THiloDescarga.descargar(url, destino: string): boolean;
begin
	FURL := url;
	FDestino := destino;

	iniciar(true);
	arrancar();

	result := true;
end;



end.