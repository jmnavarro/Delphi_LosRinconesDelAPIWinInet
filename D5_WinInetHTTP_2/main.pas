//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: main.pas
//
// Propósito:
//    Formulario principal.
//
// Autor:          José Manuel Navarro (http://www.lawebdejm.com/)
// Fecha:          01/08/2003
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 16 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ActnList, CheckLst, wininet;

type
  TMainForm = class(TForm)
    i_icono: TImage;
    l_jm: TLabel;
    p_funciones: TPanel;
    l_url: TLabel;
    l_conexion: TLabel;
    sh_funcion: TShape;
    p_aux: TPanel;
    pc_funciones: TPageControl;
    l_rincones: TLabel;
    l_wininet: TLabel;
    l_sintesis: TLabel;
    ts_login: TTabSheet;
    Button1: TButton;
    ts_sendform: TTabSheet;
    b_enviar: TButton;
    e_nombre: TEdit;
    e_pais: TEdit;
    Label3: TLabel;
    Label1: TLabel;
    m_comentario: TMemo;
    Bevel1: TBevel;
    e_url: TEdit;
    Label2: TLabel;
    rb_estandar: TRadioButton;
    rb_personalizada: TRadioButton;
    Label4: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    m_contenido: TMemo;
    Label5: TLabel;
    Bevel4: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CambioFunciones(Sender: TObject);
    procedure l_jmClick(Sender: TObject);
    procedure l_rinconesClick(Sender: TObject);
    procedure l_wininetClick(Sender: TObject);
    procedure l_sintesisClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure b_enviarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLabelFunciones: array[1..2] of TLabel;
    FLabelActiva: TLabel;

    function GuardarRespuesta(hReq: HINTERNET; filename: string): boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}


uses ShellAPI, login;

const
   FICHERO_RESPUESTA = 'c:\respuesta.htm';



//
// Función global y eventos para hacer hiperenlaces
//
function LinkTo(const url: string): boolean;
begin
   result := HINSTANCE_ERROR <= ShellExecute( GetForegroundWindow(), nil,
                                              PChar(url), nil, nil, SW_NORMAL);
end;


procedure TMainForm.l_jmClick(Sender: TObject);
begin
   if LinkTo('http://www.lawebdejm.com/') then
      (Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.l_rinconesClick(Sender: TObject);
begin
   if LinkTo('http://www.lawebdejm.com/prog/win32/') then
      (Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.l_wininetClick(Sender: TObject);
begin
   if LinkTo('http://www.lawebdejm.com/prog/delphi/wininethttp_2.html') then
      (Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.l_sintesisClick(Sender: TObject);
begin
   if LinkTo('http://www.grupoalbor.com/Sintesis/Sintesis.htm') then
      (Sender as TLabel).Font.Color := clPurple;
end;




procedure TMainForm.FormCreate(Sender: TObject);
var
   icono: HICON;
begin
   // truquillo para mostrar en un TImage el icono de la aplicación.
   icono := SendMessage(Self.handle, WM_GETICON, ICON_BIG, 0);
   i_icono.Picture.Icon.Handle := icono;

   color := $f2f4f2;

   FLabelFunciones[1] := l_url;
   FLabelFunciones[2] := l_conexion;

   FLabelActiva := FLabelFunciones[1];
end;



procedure TMainForm.CambioFunciones(Sender: TObject);
var
   i: integer;
   encontrado: integer;
begin
   if FLabelActiva = sender then
      exit;

   encontrado := -1;
   for i:=1 to 2 do
      if FLabelFunciones[i] = sender then
      begin
         encontrado := i;
         break;
      end;

   if encontrado = -1 then
      exit;

   //
   // restaurar la anterior
   //
   FLabelActiva.Cursor := crHandPoint;
   FLabelActiva.Font.Color := clBlue;

   //
   // cambiar la nueva activa
   //
   FLabelActiva := FLabelFunciones[encontrado];

   FLabelActiva.Cursor := crDefault;
   FLabelActiva.Font.Color := clBlack;

   //
   // Mover el shape
   //
   sh_funcion.top := FLabelActiva.top - 6;
   p_aux.top := sh_funcion.top + 1;

   pc_funciones.ActivePageIndex := encontrado - 1;
end;



procedure TMainForm.Button1Click(Sender: TObject);
const
	BUFF_SIZE = 1024;

   HOST    = 'www.lawebdejm.com';
   RECURSO = '/prog/win32/img/prv/datos.txt';

var
	hInet: HINTERNET;
   hConn: HINTERNET;
   hReq:  HINTERNET;

   data:   DWORD;
   size,
   dummy:  Cardinal;
   nilptr: Pointer;
	tipo,
   ret:    DWORD;

   destino: TMemoryStream;
   buff:    PByte;
	copiado: DWORD;

   continuar: boolean;
   cancelado: boolean;

   procedure Terminar;
   begin
		if hConn <> nil then
      	InternetCloseHandle(hConn);

		if hReq <> nil then
      	InternetCloseHandle(hReq);

	   if hInet <> nil then
      	InternetCloseHandle(hInet);

		Screen.cursor := crDefault;
   end;


	function MostrarLogin(hPet: HINTERNET): DWORD;
	var
   	username: string;
      password: string;
      dlg: TLoginFrm;
   begin
   	dlg := TLoginFrm.Create(self);
      try
			if dlg.ShowModal() = mrOK then
         begin
         	username := dlg.username;
            password := dlg.password;

            InternetSetOption(hPet, INTERNET_OPTION_USERNAME, PChar(username), length(username)+1);
            InternetSetOption(hPet, INTERNET_OPTION_PASSWORD, PChar(password), length(password)+1);

				result := ERROR_INTERNET_FORCE_RETRY;
         end
         else
         	result := ERROR_CANCELLED;

      finally
      	dlg.Free;
      end;
   end;

begin
	Screen.cursor := crHourglass;

	hConn := nil;
   hReq  := nil;

   hInet := InternetOpen('Descarga - Delphi',           // el user-agent
                          INTERNET_OPEN_TYPE_PRECONFIG, // configuración por defecto
                          nil, nil,                     // sin proxy
                          0 );                          // sin opciones

   if hInet = nil then
      Terminar();

   hConn := InternetConnect(hInet, HOST, INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
   if hConn = nil then
      Terminar();

   hReq := HttpOpenRequest(hConn, 'GET', RECURSO, 'HTTP/1.0', nil, nil, 0, 0);
   if hReq = nil then
      Terminar();

	cancelado := false;
	continuar := true;

   while continuar do
   begin
	   if HttpSendRequest(hReq, nil, 0, nil, 0) then
   		tipo := ERROR_SUCCESS
      else
      	tipo := GetLastError();

	   size := sizeof(data);
	   dummy := 0;
	   HttpQueryInfo(hReq, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @data, size, dummy);

	   if (data = HTTP_STATUS_DENIED) or (data = HTTP_STATUS_PROXY_AUTH_REQ) then
      begin
      	if rb_estandar.checked then
				ret := InternetErrorDlg( handle, hReq, tipo,
                  				FLAGS_ERROR_UI_FILTER_FOR_ERRORS or
                              FLAGS_ERROR_UI_FLAGS_GENERATE_DATA or
                              FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS,
				                  nilptr )
         else
         	ret := MostrarLogin(hReq);

	      case ret of

			   ERROR_INTERNET_FORCE_RETRY:
            begin
            	continuar := true;
               cancelado := false;
            end;

            else
				begin
					continuar := false;
               cancelado := true;
				end;

	      end;
      end
		else
      	continuar := false;
   end;

   if cancelado then
   	MessageBox(handle, 'Ventana de login cancelada.', PChar(caption), MB_ICONERROR)
   else
   begin
	   destino := TMemoryStream.Create;
      buff := AllocMem(BUFF_SIZE);
      try
      	//
         // hago una lectura directa, aunque debería hacerse comprobando los datos
         // disponibles con InternetQueryDataAvailable.
         // Para ver un ejemplo de cómo debería codificarse, ver el código del artículo
         // "WinInet y HTTP".
         //
         copiado := 1;
			while copiado > 0 do
         begin
            InternetReadFile(hReq, buff, BUFF_SIZE, copiado);
            if copiado > 0 then
		      	destino.WriteBuffer(buff^, copiado);
      	end;

			// almacenar el caracter #0 terminador
			buff^ := 0;
         destino.WriteBuffer(buff, 1);

      finally
      	FreeMem(buff, BUFF_SIZE);

         MessageBox(handle, PChar('Los datos descargados han sido guardados con éxito.'),
      				  PChar(caption), MB_ICONINFORMATION);

			m_contenido.Lines.SetText(PChar(destino.Memory));
      	destino.Free;
      end;
   end;


   Terminar();
end;

procedure TMainForm.b_enviarClick(Sender: TObject);
const
   HOST      = 'www.lawebdejm.com';
   SCRIPT    = '/prog/win32/img/prv/form_wininet.php';

	USER  = 'sintesis';
   PASSW = 'pepin';
var
	cab: string;
   data: string;

	hInet: HINTERNET;
   hConn: HINTERNET;
   hReq:  HINTERNET;

   procedure Terminar;
   begin
		if hConn <> nil then
      	InternetCloseHandle(hConn);

		if hReq <> nil then
      	InternetCloseHandle(hReq);

	   if hInet <> nil then
      	InternetCloseHandle(hInet);

		Screen.cursor := crDefault;
   end;

   function GetCadenaForm: string;
      function CanonicalizeUrl(url: string): string;
      var
         buff: array[0..512] of char;
         len: cardinal;
      begin
	      len := 512;
	   	InternetCanonicalizeUrl(PChar(url), buff, len, 0);
         result := buff;
      end;
	var
   	i: integer;
      str: string;
   begin
		result := 'nombre='      + CanonicalizeUrl(e_nombre.text) +
                '&pais='       + CanonicalizeUrl(e_pais.text)   +
                '&comentario=';
      for i:=0 to m_comentario.Lines.count-1 do
      begin
      	str    := CanonicalizeUrl(m_comentario.Lines[i]) + '%0D%0A';  // %0D%0A = #10#13
      	result := result + str;
      end;
   end;

begin
	cab  := 'Content-Type: application/x-www-form-urlencoded';
   data := GetCadenaForm();

	Screen.cursor := crHourglass;

	hConn := nil;
   hReq  := nil;

   hInet := InternetOpen('Post - Delphi',               // el user-agent
                          INTERNET_OPEN_TYPE_PRECONFIG, // configuración por defecto
                          nil, nil,                     // sin proxy
                          0 );                          // sin opciones

   if hInet = nil then
      Terminar();

	// el recurso está protegido con contraseña, así que se pasa el usuario y clave
   // directamente aquí (tambien puede hacerse siguiendo el otro método).
   hConn := InternetConnect(hInet, HOST, INTERNET_DEFAULT_HTTP_PORT,
   		 						 USER, PASSW,
                            INTERNET_SERVICE_HTTP, 0, 0);
   if hConn = nil then
      Terminar();

   hReq := HttpOpenRequest(hConn, 'POST', SCRIPT, nil, nil, nil, 0, 0);
   if hReq = nil then
      Terminar();

   HttpSendRequest(hReq, PChar(cab), Length(cab), PChar(data), Length(data));

	if GuardarRespuesta(hReq, FICHERO_RESPUESTA) then
   begin
   	MessageBox(handle, PChar('Los datos descargados han sido recibidos por el servidor y se ha generado una página de respuesta.' +
                         #10#13#10#13'A continuación se abrirá el '+
                         'explorador por defecto para mostrar la página "' + FICHERO_RESPUESTA + '".'),
                         PChar(caption), MB_ICONINFORMATION);
      LinkTo(FICHERO_RESPUESTA);
   end
   else
   	MessageBox(handle, PChar('No se ha podido leer ninguna respuesta.'), PChar(caption),
                         MB_ICONINFORMATION);

	Screen.cursor := crDefault;
end;


function TMainForm.GuardarRespuesta(hReq: HINTERNET; filename: string): boolean;
const
	BUFF_SIZE = 1024;
var
   destino: TFileStream;
   buff:    PByte;
	copiado: DWORD;
begin
   destino := TFileStream.Create(filename, fmCreate);
   buff := AllocMem(BUFF_SIZE);
   try
      //
      // hago una lectura directa, aunque debería hacerse comprobando los datos
      // disponibles con InternetQueryDataAvailable.
      // Para ver un ejemplo de cómo debería codificarse, ver el código del artículo
      // "WinInet y HTTP".
      //
      copiado := 1;
      while copiado > 0 do
      begin
         InternetReadFile(hReq, buff, BUFF_SIZE, copiado);
         if copiado > 0 then
            destino.Write(buff^, copiado);
      end;

	   result := (destino.Size > 0);

   finally
      FreeMem(buff, BUFF_SIZE);
      destino.Free;
   end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	DeleteFile(FICHERO_RESPUESTA);
end;

end.
