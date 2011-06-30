//---------------------------------------------------------------------------------------------
//
// Archivo: HiloDescarga.pas
//
// Propósito:
//    Se trata de un descendiente de la clase THiloDescarga, que sobrescribe los métodos
//    virtuales "OnXXX" para reaccionar ante los eventos producidos por la descarga.
//    En estos eventos se accede (de forma sincronizada a través de una sección crítica)
//    a los distintos componentes de la ventana.
//
// Autor:          José Manuel Navarro - http://www.lawebdejm.com
// Fecha:          01/05/2004
// Observaciones:  Unidad creada en Delphi 5.
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//---------------------------------------------------------------------------------------------
unit HiloDescargaEventos;

interface

uses HiloDescarga, Windows, MainFrm, Classes;

type
	THiloDescargaEventos = class(THiloDescarga)
	private
		FProtegerVCL: RTL_CRITICAL_SECTION;

		FVentana: TMainForm;

		function getIniFile: string;

	protected
		//
		// eventos
		//
		function  onBeginDownload(var byteIni: DWORD; var byteFin: DWORD; size: DWORD): boolean; override;
		procedure onEndDownload(totalBytes: DWORD); override;
		function  onProcessDownload(currentBytes: DWORD): boolean; override;
		procedure onCancelDownload(currentByte: DWORD); override;

	public
		constructor Create;
		destructor Destroy; override;

		function getDescargasPendientes(lista: TStrings): integer;
		function getDatosDescarga(url: string; var filename: string; var size: DWORD; var lastByte: DWORD): boolean;

		property Ventana: TMainForm read FVentana write FVentana;
	end;


implementation


uses IniFiles, Forms, SysUtils, ShellAPI;


constructor THiloDescargaEventos.Create;
begin
	inherited;
	InitializeCriticalSection(FProtegerVCL);
end;


destructor THiloDescargaEventos.Destroy;
begin
	DeleteCriticalSection(FProtegerVCL);
	inherited;
end;


function THiloDescargaEventos.getIniFile: string;
begin
	result := ExtractFilePath(Application.ExeName);
	result := IncludeTrailingBackslash(result) + 'descarga.ini';
end;

//
// eventos
//
function  THiloDescargaEventos.onBeginDownload(var byteIni: DWORD; var byteFin: DWORD; size: DWORD): boolean;
var
	ultimoByte: DWORD;
	msg: string;
	ini: TIniFile;
begin
	msg := Format('Inicio de descarga [%d - %d]', [byteIni, byteFin]);

	EnterCriticalSection(FProtegerVCL);
	try
		ini := TIniFile.Create(getIniFile);
		try
			ultimoByte := ini.ReadInteger(URL, 'lastByte', 0);
		finally
			ini.Free;
		end;

		if ultimoByte > 0 then
		begin
			byteIni := ultimoByte;
			byteFin := 0; // hasta el final
		end;

		FVentana.progreso.Min := 0;
		FVentana.progreso.Max := size;

		FVentana.lb_log.ItemIndex := ventana.lb_log.Items.Add(msg);

	finally
		LeaveCriticalSection(FProtegerVCL);
	end;

	result := true;
end;


procedure THiloDescargaEventos.onEndDownload(totalBytes: DWORD);
var
	msg: string;
	ini: TIniFile;
	ind: integer;
begin
	msg := Format('Fin de descarga [%d]', [totalBytes]);

	EnterCriticalSection(FProtegerVCL);
	try
		FVentana.lb_log.ItemIndex := FVentana.lb_log.Items.Add(msg);
		FVentana.ParadaDescarga();

		ini := TIniFile.Create(getIniFile);
		try
			ini.EraseSection(URL);
		finally
			ini.Free;
		end;

		if totalBytes > 0 then
		begin
			ind := FVentana.lb_url.Items.IndexOf(URL);
			if ind <> -1 then
				FVentana.lb_url.Items.Delete(ind);

			MessageBox(FVentana.Handle, 'Descarga finalizada correctamente.'#10#13'A continuación se abrirá la carpeta donde se ha guardado del archivo descargado.', PChar(ventana.Caption), MB_ICONINFORMATION);

			ShellExecute(GetForegroundWindow(), nil, PChar(FVentana.e_carpeta.Text),
							nil, nil, SW_NORMAL);
		end
		else
			MessageBox(FVentana.Handle, 'No se ha descargando el recurso. Comprueba que la conexión esté activa y la URL sea correcta.', PChar(ventana.Caption), MB_ICONINFORMATION);

	finally
		LeaveCriticalSection(FProtegerVCL);
	end;
end;


function  THiloDescargaEventos.onProcessDownload(currentBytes: DWORD): boolean;
var
	msg: string;
begin
	msg := Format('Progreso [%d]', [currentBytes]);

	EnterCriticalSection(FProtegerVCL);
	try
		FVentana.progreso.Position := currentBytes;

		if FVentana.lb_log.Items.Count >= 100 then
			FVentana.lb_log.Items.Delete(0);

		FVentana.lb_log.ItemIndex := FVentana.lb_log.Items.Add(msg);

	finally
		LeaveCriticalSection(FProtegerVCL);
	end;

	result := true;
end;


procedure THiloDescargaEventos.onCancelDownload(currentByte: DWORD);
var
	msg: string;
	ini: TIniFile;
begin
	EnterCriticalSection(FProtegerVCL);
	try
		ini := TIniFile.Create(getIniFile);
		try
			if currentByte > 0 then
			begin
				ini.WriteString(URL,  'filename', Destino);
				ini.WriteInteger(URL, 'lastByte', currentByte);
			end;

			if FVentana.lb_url.Items.IndexOf(URL) = -1 then
				FVentana.lb_url.Items.Add(URL);
		finally
			ini.Free;
		end;

		msg := Format('Descarga cancelada [%d]', [currentByte]);

		FVentana.lb_log.ItemIndex := FVentana.lb_log.Items.Add(msg);
		FVentana.ParadaDescarga();
	finally
		LeaveCriticalSection(FProtegerVCL);
	end;
end;


function THiloDescargaEventos.getDescargasPendientes(lista: TStrings): integer;
var
	ini: TIniFile;
begin
	result := lista.Count;

	ini := TIniFile.Create(getIniFile);
	try
		ini.ReadSections(lista);
	finally
		ini.Free;
	end;

	result := (lista.Count - result);
end;


function THiloDescargaEventos.getDatosDescarga(url: string; var filename: string; var size: DWORD; var lastByte: DWORD): boolean;
var
	ini: TIniFile;
	hFile: THandle;
begin
	ini := TIniFile.Create(getIniFile);
	try
		filename := ini.ReadString(url,  'filename', '');
		lastByte := ini.ReadInteger(url, 'lastByte', 0);
	finally
		ini.Free;
	end;

	if filename = '' then
		size := 0
	else
	begin
		hFile := CreateFile(PChar(filename), GENERIC_READ, FILE_SHARE_READ,
							nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
		size := GetFileSize(hFile, nil);
		if size = $FFFFFFFF then
			size := 0;

		CloseHandle(hFile);
	end;

	result := (filename <> '');
end;


end.