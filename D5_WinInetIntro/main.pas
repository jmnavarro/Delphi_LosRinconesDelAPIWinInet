//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: main.pas
//
// Propósito:
//    Formulario principal.
//
// Autor:          José Manuel Navarro (jose_manuel_navarro@yahoo.es)
// Fecha:          01/04/2003
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 14 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ActnList, CheckLst, Ejecutar;

type
  TMainForm = class(TForm)
    i_icono: TImage;
    l_jm: TLabel;
    acciones: TActionList;
    InetCanonicalizeUrl: TAction;
    InetCombineUrl: TAction;
    InetCrackUrl: TAction;
    InetCreateUrl: TAction;
    p_funciones: TPanel;
    l_url: TLabel;
    l_conexion: TLabel;
    sh_funcion: TShape;
    p_aux: TPanel;
    pc_funciones: TPageControl;
    ts_url: TTabSheet;
    ts_conexion: TTabSheet;
    pc_url: TPageControl;
    ts_canonicalize: TTabSheet;
    ts_combine: TTabSheet;
    ts_crack: TTabSheet;
    ts_create: TTabSheet;
    e_canonicalizeUrl: TEdit;
    CanonicalizeFlags: TCheckListBox;
    e_canonicalizeResult: TEdit;
    CanonicalizeUrlFrame: TEjecutarFrame;
    e_combineBaseUrl: TEdit;
    e_combineRelativaUrl: TEdit;
    CombineFlags: TCheckListBox;
    e_combineResult: TEdit;
    CombineUrlFrame: TEjecutarFrame;
    CrackUrlFrame: TEjecutarFrame;
    CreateUrlFrame: TEjecutarFrame;
    e_crackUrl: TEdit;
    CrackFlags: TCheckListBox;
    lv_components: TListView;
    lv_create: TListView;
    CreateFlags: TCheckListBox;
    e_createResult: TEdit;
    pc_conexion: TPageControl;
    ts_network: TTabSheet;
    ts_destination: TTabSheet;
    ts_attempt: TTabSheet;
    ts_connected: TTabSheet;
    ts_goonline: TTabSheet;
    NetworkAliveFrame: TEjecutarFrame;
    DestinationFrame: TEjecutarFrame;
    AttemptFrame: TEjecutarFrame;
    ConnectedFrame: TEjecutarFrame;
    GoOnlineFrame: TEjecutarFrame;
    InetNetworkAlive: TAction;
    InetDestinationReachable: TAction;
    InetAttemptConnect: TAction;
    InetGetConnectedState: TAction;
    InetGoOnline: TAction;
    ConnectedFlags: TCheckListBox;
    e_goonline: TEdit;
    m_notas: TMemo;
    NAFlags: TCheckListBox;
    DRFlags: TCheckListBox;
    e_UrlDR: TEdit;
    l_inspeed: TLabel;
    l_outspeed: TLabel;
    l_rincones: TLabel;
    l_wininet: TLabel;
    l_sintesis: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure InetCanonicalizeUrlExecute(Sender: TObject);
    procedure InetCombineUrlExecute(Sender: TObject);
    procedure InetCrackUrlExecute(Sender: TObject);
    procedure CambioFunciones(Sender: TObject);
    procedure InetCreateUrlExecute(Sender: TObject);
    procedure lv_createDblClick(Sender: TObject);
    procedure lv_createEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure InetAttemptConnectExecute(Sender: TObject);
    procedure ConnectedFlagsClickCheck(Sender: TObject);
    procedure InetGetConnectedStateExecute(Sender: TObject);
    procedure InetGoOnlineExecute(Sender: TObject);
    procedure InetNetworkAliveExecute(Sender: TObject);
    procedure InetDestinationReachableExecute(Sender: TObject);
    procedure l_jmClick(Sender: TObject);
    procedure l_rinconesClick(Sender: TObject);
    procedure l_wininetClick(Sender: TObject);
    procedure l_sintesisClick(Sender: TObject);
  private
    FLabelFunciones: array[1..2] of TLabel;
    FLabelActiva: TLabel;

    procedure InitFunciones;

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}


uses wininet, shellapi;


const
   WININET_DLL = 'wininet.dll';
   SENSAPI_DLL = 'sensapi.dll';

   // para IsNetworkAlive e IsDestinationReachable
   NETWORK_ALIVE_LAN = $00000001;
   NETWORK_ALIVE_WAN = $00000002;

   FLAGS_NETWORK: array[0..1] of DWORD = (
        NETWORK_ALIVE_LAN,
        NETWORK_ALIVE_WAN
   );


   // para GetConnectedState
   INTERNET_CONNECTION_MODEM      = $01;
   INTERNET_CONNECTION_LAN        = $02;
   INTERNET_RAS_INSTALLED         = $10;
   INTERNET_CONNECTION_OFFLINE    = $20;
   INTERNET_CONNECTION_CONFIGURED = $40;

   STATE_FLAGS: array[0..5] of DWORD = (
      INTERNET_CONNECTION_CONFIGURED,
      INTERNET_CONNECTION_LAN,
      INTERNET_CONNECTION_MODEM,
      INTERNET_CONNECTION_OFFLINE,
      INTERNET_CONNECTION_PROXY,
      INTERNET_RAS_INSTALLED
   );


   //
   // Para canonicalize y combine
   //
   ICU_ENCODE_PERCENT = $00001000; //  no está en wininet.pas de D5.

   ICU_FLAGS: array[0..4] of DWORD = (
      ICU_BROWSER_MODE,
      ICU_NO_ENCODE,
      ICU_DECODE,
      ICU_ENCODE_PERCENT,
      ICU_ENCODE_SPACES_ONLY
   );


type
   LPQOCINFO = ^QOCINFO;
   QOCINFO = packed record
      dwSize:      DWORD;
      dwFlags:     DWORD;
      dwInSpeed:   DWORD;
      dwOutSpeed:  DWORD;
   end;

//
// Punteros a funciones para la carga dinámica de las funciones a partir de IE 4
//
type
   TIsNetworkAlive = function(dwTipoConexion: LPDWORD): BOOL; stdcall;
   TIsDestinationReachable = function(url: LPCSTR; qcinfo: LPQOCINFO): BOOL; stdcall;
   TInternetGoOnline = function(URL: LPTSTR; hParent: HWND; dwFlags: DWORD): BOOL; stdcall;
   TInternetGetConnectedState = function(lpdwFlags: LPDWORD; dwReserved: DWORD): BOOL; stdcall;



//
// Función global y eventos para hacer hyperenlaces
//
function LinkTo(const url: string): boolean;
begin
   result := HINSTANCE_ERROR <= ShellExecute( GetForegroundWindow, nil,
                                              PChar(url),
                                              nil, nil, SW_NORMAL);
end;


procedure TMainForm.l_jmClick(Sender: TObject);
begin
   if LinkTo('http://users.servicios.retecal.es/sapivi/') then
      (Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.l_rinconesClick(Sender: TObject);
begin
   if LinkTo('http://users.servicios.retecal.es/sapivi/prog/win32') then
      (Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.l_wininetClick(Sender: TObject);
begin
   if LinkTo('http://users.servicios.retecal.es/sapivi/prog/delphi/wininetintro.html') then
      (Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.l_sintesisClick(Sender: TObject);
begin
   if LinkTo('http://www.grupoalbor.com/Sintesis/Sintesis.htm') then
      (Sender as TLabel).Font.Color := clPurple;
end;




procedure TMainForm.InitFunciones;
begin
   // url
   CanonicalizeUrlFrame.Init(InetCanonicalizeUrl);
   CombineUrlFrame.Init(InetCombineUrl);
   CrackUrlFrame.Init(InetCrackUrl);
   CreateUrlFrame.Init(InetCreateUrl);

   // conexión
   NetworkAliveFrame.Init(InetNetworkAlive);
   DestinationFrame.Init(InetDestinationReachable);
   AttemptFrame.Init(InetAttemptConnect);
   ConnectedFrame.Init(InetGetConnectedState);
   GoOnlineFrame.Init(InetGoOnline);
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

   InitFunciones();
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



procedure TMainForm.lv_createDblClick(Sender: TObject);
var
   ret: string;
begin
   ret := InputBox('Modificar valor',
               'Introduce el valor para el componente ' + lv_create.ItemFocused.Caption,
                lv_create.ItemFocused.SubItems[0]);

   if ret <> lv_create.ItemFocused.SubItems[0] then
      lv_create.ItemFocused.SubItems[0] := ret;
end;



procedure TMainForm.lv_createEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
begin
   AllowEdit := false;
end;



procedure TMainForm.ConnectedFlagsClickCheck(Sender: TObject);
begin
   ConnectedFlags.Checked[ConnectedFlags.ItemIndex] := not ConnectedFlags.Checked[ConnectedFlags.ItemIndex];
end;




//
// Eventos Execute de las distintas acciones
//

procedure TMainForm.InetCanonicalizeUrlExecute(Sender: TObject);
var
   buffer: array[0..255] of char;
   len: DWORD;
   flags: DWORD;
   ok: boolean;
   i: integer;
begin
   len := e_canonicalizeUrl.MaxLength;

   //
   // se establecen las opciones según se ha marcado
   //
   flags := 0;
   for i:=0 to Length(ICU_FLAGS) - 1 do
      if CanonicalizeFlags.Checked[i] then
      flags := flags or ICU_FLAGS[i];

   ok := InternetCanonicalizeUrl(PChar(e_canonicalizeUrl.text), buffer, len, flags);
   if ok then
   begin
      e_canonicalizeResult.text := buffer;
      (Sender as TAction).tag := 1;
   end
   else
      (Sender as TAction).tag := GetLastError();
end;



procedure TMainForm.InetCombineUrlExecute(Sender: TObject);
var
   buffer: array[0..255] of char;
   len: DWORD;
   flags: DWORD;
   ok: boolean;
   i: integer;
begin
   len := 255;

   //
   // se establecen las opciones según se ha marcado
   //
   flags := 0;
   for i:=0 to Length(ICU_FLAGS) - 1 do
      if CombineFlags.Checked[i] then
         flags := flags or ICU_FLAGS[i];

   ok := InternetCombineUrl( PChar(e_combineBaseUrl.text),
                             PChar(e_combineRelativaUrl.text),
                             buffer, len, flags);
   if ok then
   begin
      e_combineResult.text := buffer;
      (Sender as TAction).tag := 1;
   end
   else
      (Sender as TAction).tag := GetLastError();
end;



procedure TMainForm.InetCrackUrlExecute(Sender: TObject);
const
   MAX_BUFFER = 256;

   ICU_FLAGS: array[0..1] of DWORD = (
      ICU_DECODE,
      ICU_ESCAPE
   );
var
   componentes: URL_COMPONENTS;
   buffers: array[0..5, 0..MAX_BUFFER-1] of char;
   flags: DWORD;
   i: integer;
   ok: boolean;


   procedure ShowResult(compo: LPURL_COMPONENTS);
   var
      item: TListItem;
   begin
      lv_components.Items.Clear;

      item := lv_components.Items.Add;
      item.Caption := 'Scheme';
      item.SubItems.add(compo.lpszScheme);

      item := lv_components.Items.Add;
      item.Caption := 'Host';
      item.SubItems.add(compo.lpszHostName);

      item := lv_components.Items.Add;
      item.Caption := 'Port';
      item.SubItems.add(IntToStr(compo.nPort));

      item := lv_components.Items.Add;
      item.Caption := 'Username';
      item.SubItems.add(compo.lpszUserName);

      item := lv_components.Items.Add;
      item.Caption := 'Password';
      item.SubItems.add(compo.lpszPassword);

      item := lv_components.Items.Add;
      item.Caption := 'Path';
      item.SubItems.add(compo.lpszUrlPath);

      item := lv_components.Items.Add;
      item.Caption := 'Extra';
      item.SubItems.add(compo.lpszExtraInfo);

      lv_components.Columns[1].AutoSize := true;
      lv_components.Columns[1].width := -1;
   end;

begin
   ZeroMemory(@componentes, sizeof(URL_COMPONENTS));
   componentes.dwStructSize := sizeof(URL_COMPONENTS);

   //
   // se asigna los 5 buffers a los componentes
   //
   componentes.dwSchemeLength := MAX_BUFFER-1;
   componentes.lpszScheme := buffers[0];

   componentes.dwHostNameLength := MAX_BUFFER-1;
   componentes.lpszHostName := buffers[1];

   componentes.dwUserNameLength := MAX_BUFFER-1;
   componentes.lpszUserName := buffers[2];

   componentes.dwPasswordLength := MAX_BUFFER-1;
   componentes.lpszPassword := buffers[3];

   componentes.dwUrlPathLength := MAX_BUFFER-1;
   componentes.lpszUrlPath := buffers[4];

   componentes.dwExtraInfoLength := MAX_BUFFER-1;
   componentes.lpszExtraInfo := buffers[5];

   //
   // las banderas de opciones
   //
   flags := 0;
   for i:=0 to CrackFlags.Items.Count - 1 do
      flags := flags OR ICU_FLAGS[i];

   ok := InternetCrackURL(PChar(e_crackUrl.text), 0, flags, componentes);
   if ok then
   begin
      ShowResult(@componentes);
      (Sender as TAction).tag := 1;
   end
   else
      (Sender as TAction).tag := GetLastError();
end;



procedure TMainForm.InetCreateUrlExecute(Sender: TObject);
const
   MAX_BUFFER = 256;
   MAX_COMPOS = 6;
type
   TMatrizChars = array[0..MAX_COMPOS] of PChar;
   TVectorSize  = array[0..MAX_COMPOS] of integer;
var
   componentes: URL_COMPONENTS;
   flags: DWORD;
   len: DWORD;
   resultado: array[0..511] of char;
   buffers: TMatrizChars;
   sizes: TVectorSize;
   ok: boolean;

   procedure LoadComponents;
   var
      i: integer;
   begin
      componentes.dwStructSize := sizeof(URL_COMPONENTS);
      //
      // paso los datos del listview a una matriz de caracteres.
      //
      for i:=0 to MAX_COMPOS do
         if lv_create.Items[i].SubItems[0] <> '' then
         begin
            sizes[i] := Length(lv_create.Items[i].SubItems[0]) + 1;
            buffers[i] := AllocMem(sizes[i]); // reserva dinámica
            StrPCopy(buffers[i], lv_create.Items[i].SubItems[0]);
         end
         else
            buffers[i] := nil;

      //
      // asigno cada fila de la matriz a su correspondiente componente
      //
      componentes.lpszScheme := buffers[0];
      if buffers[0] = nil then
         componentes.dwSchemeLength := 0
      else
         componentes.dwSchemeLength := sizes[0] - 1;


      componentes.lpszHostName := buffers[1];
      if buffers[1] = nil then
         componentes.dwHostNameLength := 0
      else
         componentes.dwHostNameLength := sizes[1] - 1;


      componentes.nPort := StrToInt(buffers[2]);


      componentes.lpszUserName := buffers[3];
      if buffers[3] = nil then
         componentes.dwUserNameLength := 0
      else
         componentes.dwUserNameLength := sizes[3] - 1;


      componentes.lpszPassword := buffers[4];
      if buffers[4] = nil then
         componentes.dwPasswordLength := 0
      else
         componentes.dwPasswordLength := sizes[4] - 1;


      componentes.lpszUrlPath := buffers[5];
      if buffers[5] = nil then
         componentes.dwUrlPathLength := 0
      else
         componentes.dwUrlPathLength := sizes[5] - 1;


      componentes.lpszExtraInfo := buffers[6];
      if buffers[6] = nil then
         componentes.dwExtraInfoLength := 0
      else
         componentes.dwExtraInfoLength := sizes[6] - 1;
   end;

begin
   LoadComponents;

   if CreateFlags.Checked[0] then
      flags := ICU_ESCAPE
   else
      flags := 0;


   len := 511;
   ok := InternetCreateUrl(componentes, flags, resultado, len);
   if ok then
   begin
      e_createResult.text := resultado;
      (Sender as TAction).tag := 1;
   end
   else
      (Sender as TAction).tag := GetLastError();

   //
   // liberar cada fila de la matriz, que ha sido reservada dinámicamente.
   //
   for len:=0 to MAX_COMPOS do
      if buffers[len] <> nil then
         FreeMem(buffers[len], sizes[len]);
end;



procedure TMainForm.InetAttemptConnectExecute(Sender: TObject);
var
   ret: DWORD;
begin
   ret := InternetAttemptConnect(0);
   if (ERROR_SUCCESS = ret) then
      (Sender as TAction).tag := 1
   else
      (Sender as TAction).tag := ret;
end;



procedure TMainForm.InetGetConnectedStateExecute(Sender: TObject);
var
   flags: DWORD;
   i: integer;
   InternetGetConnected: TInternetGetConnectedState;
   h: THandle;
   freeDLL: boolean;
begin
   (Sender as TAction).tag := 0;

   Screen.Cursor := crHourGlass;
   try
      h := GetModuleHandle(WININET_DLL);
      freeDLL := (h = 0);
      if h = 0 then
         h := LoadLibrary(WININET_DLL);

         if h = 0 then
            ConnectedFrame.l_retorno.caption := 'No se ha encontrado la librería wininet.dll'
      else
      begin
         try
            @InternetGetConnected := GetProcAddress(h, 'InternetGetConnectedState');
            if @InternetGetConnected =  nil then
               ConnectedFrame.l_retorno.caption := 'No se ha encontrado la función InternetGetConnectedState'
            else
            begin
               if InternetGetConnected(@flags, 0) then
                  ConnectedFrame.l_retorno.caption := 'Hay conexión a internet'
               else
                  ConnectedFrame.l_retorno.caption := 'No hay conexión a internet';

               for i:=0 to Length(STATE_FLAGS) - 1 do
                  ConnectedFlags.Checked[i] := (STATE_FLAGS[i] and flags <> 0);
            end;
         finally
            if freeDLL then
               FreeLibrary(h);
         end;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;



procedure TMainForm.InetGoOnlineExecute(Sender: TObject);
var
   InternetGo: TInternetGoOnline;
   h: THandle;
   freeDll: boolean;
begin
   (Sender as TAction).tag := 0;

   h := GetModuleHandle(WININET_DLL);
   freeDLL := (h = 0);
   if h = 0 then
      h := LoadLibrary(WININET_DLL);


   if h = 0 then
      GoOnlineFrame.l_retorno.caption := 'No se ha encontrado la librería wininet.dll'
   else
   begin
      try
         @InternetGo := GetProcAddress(h, 'InternetGoOnlineA');
         if @InternetGo = nil then
            GoOnlineFrame.l_retorno.caption := 'No se ha encontrado la función InternetGoOnline.'
         else
         begin
            if InternetGo(PChar(e_goonline.text), self.handle, 0) then
               GoOnlineFrame.l_retorno.caption := 'Bandera "Trabajar sin conexión" bajada.'
            else
               if GetLastError() <> 0 then
                  (Sender as TAction).tag := GetLastError()
               else
                  GoOnlineFrame.l_retorno.caption := 'La bandera "Trabajar sin conexión" continúa activa.'
         end;
      finally
         if freeDLL then
            FreeLibrary(h);
      end;
   end;
end;



procedure TMainForm.InetNetworkAliveExecute(Sender: TObject);
var
   h: THandle;
   IsNetworkAlive: TIsNetworkAlive;
   tipo: DWORD;
   i: integer;
begin
   (Sender as TAction).tag := 0;

   h := LoadLibrary(SENSAPI_DLL);
   if h = 0 then
      NetworkAliveFrame.l_retorno.caption := Format('No se ha encontrado la librería %s.', [SENSAPI_DLL])
   else
   begin
      try
         @IsNetworkAlive := GetProcAddress(h, 'IsNetworkAlive');
         if @IsNetworkAlive = nil then
            NetworkAliveFrame.l_retorno.caption := 'No se ha encontrado la función IsNetworkAlive.'
         else
         begin
            tipo := 0;
            for i:=0 to NAFlags.Items.Count - 1 do
               if NAFlags.Checked[i] then
                  tipo := tipo or FLAGS_NETWORK[i];

            if IsNetworkAlive(@tipo) then
               (Sender as TAction).tag := 1
            else
               (Sender as TAction).tag := GetLastError();

         end;
      finally
         FreeLibrary(h);
      end;
   end;
end;



procedure TMainForm.InetDestinationReachableExecute(Sender: TObject);
var
   h: THandle;
   IsDestinationReachable: TIsDestinationReachable;
   qcinfo: QOCINFO;
   i: integer;
begin
   (Sender as TAction).tag := 0;

   h := LoadLibrary(SENSAPI_DLL);
   if h = 0 then
      DestinationFrame.l_retorno.caption := Format('No se ha encontrado la librería %s.', [SENSAPI_DLL])
   else
   begin
      try
         @IsDestinationReachable := GetProcAddress(h, 'IsDestinationReachableA');
         if @IsDestinationReachable = nil then
            DestinationFrame.l_retorno.caption := 'No se ha encontrado la función IsDestinationReachable.'
         else
         begin
            qcinfo.dwSize := sizeof(QOCINFO);
            qcinfo.dwFlags := 0;
            for i:=0 to DRFlags.Items.Count - 1 do
               if DRFlags.Checked[i] then
                  qcinfo.dwFlags := qcinfo.dwFlags or FLAGS_NETWORK[i];

            if IsDestinationReachable(PChar(e_UrlDR.text), @qcinfo) then
            begin
               l_inSpeed.caption  := Format('%d KB/s.', [qcinfo.dwInSpeed]);
               l_outSpeed.caption := Format('%d KB/s.', [qcinfo.dwOutSpeed]);
               (Sender as TAction).tag := 1;
            end
            else
               (Sender as TAction).tag := GetLastError();

         end;
      finally
         FreeLibrary(h);
      end;
   end;
end;




end.
