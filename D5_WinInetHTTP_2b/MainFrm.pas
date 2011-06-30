//---------------------------------------------------------------------------------------------
//
// Archivo: HiloDescarga.pas
//
// Propósito:
//    Formulario principal.
//
// Autor:          José Manuel Navarro - http://www.lawebdejm.com
// Fecha:          01/05/2004
// Observaciones:  Unidad creada en Delphi 5.
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//---------------------------------------------------------------------------------------------
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, HiloDescarga;

type
  TMainForm = class(TForm)
    i_icono: TImage;
    l_wininet: TLabel;
    l_sintesis: TLabel;
    l_jm: TLabel;
    s_borde: TShape;
    l_rincones: TLabel;
    p_funciones: TPanel;
    Label2: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    Bevel2: TBevel;
    Panel1: TPanel;
    Image1: TImage;
    lb_url: TListBox;
    b_eliminar: TButton;
    e_carpeta: TEdit;
    b_descargar: TButton;
    progreso: TProgressBar;
    lb_log: TListBox;
    Panel2: TPanel;
    e_url: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure l_jmClick(Sender: TObject);
    procedure l_rinconesClick(Sender: TObject);
    procedure l_wininetClick(Sender: TObject);
    procedure l_sintesisClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure b_descargarClick(Sender: TObject);
    procedure lb_urlClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure b_eliminarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
		FDescargando: boolean;
		FCancelando: boolean;

		hilo: THiloDescarga;

  public
    procedure ParadaDescarga;
  end;


var
  MainForm: TMainForm;


implementation

{$R *.DFM}


uses ShellAPI, HiloDescargaEventos, FileCtrl;


//
// Función global y eventos para hacer hiperenlaces
//
function LinkTo(const url: string): boolean;
begin
   result := HINSTANCE_ERROR <= ShellExecute( GetForegroundWindow(), nil,
                                              PChar(url), nil, nil, SW_NORMAL);
end;



procedure TMainForm.ParadaDescarga;
begin
	b_descargar.Caption := 'Descargar';
	b_descargar.Enabled := true;
	FDescargando := false;
	FCancelando := false;
end;


procedure TMainForm.FormCreate(Sender: TObject);
var
	buff: array[0..MAX_PATH-1] of char;
	icono: HICON;
begin
	FDescargando := false;
	FCancelando := false;

	// truquillo para mostrar en un TImage el icono de la aplicación.
	icono := SendMessage(Self.handle, WM_GETICON, ICON_BIG, 0);
	i_icono.Picture.Icon.Handle := icono;

	hilo := THiloDescargaEventos.Create;
	(hilo as THiloDescargaEventos).Ventana := Self;
	(hilo as THiloDescargaEventos).getDescargasPendientes(lb_url.Items);
	b_eliminar.Enabled := (lb_url.Items.Count > 0);

	if lb_url.Items.Count = 1 then
	begin
		lb_url.ItemIndex := 0;
		lb_url.OnClick(Self);
	end;

	GetTempPath(MAX_PATH, buff);
	e_carpeta.Text := buff;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
	hilo.Free;
	hilo := nil;
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
	if LinkTo('http://www.lawebdejm.com/prog/delphi/wininethttp_2.html#apdo8') then
		(Sender as TLabel).Font.Color := clPurple;
end;


procedure TMainForm.b_descargarClick(Sender: TObject);
var
	url: string;
begin
	if FDescargando then
	begin
		hilo.Cancelado := true;
		b_descargar.Caption := 'Cancelando...';
		b_descargar.Enabled := false;
		FCancelando := true;
	end
	else
	begin
		url := 'http://' + e_url.Text;

		if (Trim(e_url.Text) = '') or (Trim(e_carpeta.Text) = '') or (not DirectoryExists(e_carpeta.Text)) then
		begin
			MessageBox(Handle, 'Tienes que introducir una URL y carpeta válida.', 'Descargar', MB_ICONWARNING);
			exit;
		end;

		hilo.descargar(url, ExcludeTrailingBackslash(e_carpeta.Text));
		b_descargar.Caption := 'Cancelar';
	end;

	FDescargando := not FDescargando;

end;


procedure TMainForm.lb_urlClick(Sender: TObject);
var
	size, lastByte: DWORD;
	filename, url: string;
	ret: boolean;
begin

	ret := (hilo as THiloDescargaEventos).getDatosDescarga(lb_url.Items.Strings[lb_url.ItemIndex], filename, size, lastByte);

	if ret then
	begin
		url := lb_url.Items.Strings[lb_url.ItemIndex];
		Delete(url, 1, 7);
		e_url.Text := url;
		e_carpeta.Text := ExtractFilePath(filename);

		progreso.Max := size;
		progreso.Position := lastByte;
	end;

end;


procedure TMainForm.Image1Click(Sender: TObject);
var
	dir: string;
begin
	if SelectDirectory('Examinar carpetas', '', dir) then
		e_carpeta.Text := dir;
end;


procedure TMainForm.b_eliminarClick(Sender: TObject);
begin
	if lb_url.ItemIndex <> -1 then
	begin
		lb_url.Items.Delete(lb_url.ItemIndex);
		if lb_url.Items.Count = 0 then
			b_eliminar.Enabled := false;

		lb_url.ItemIndex := 0;
	end
	else
		MessageBox(Handle, 'Selecciona un elemento de la lista para eliminarlo.', 'Eliminar', MB_ICONWARNING);
end;


procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	CanClose := (not FDescargando) and (not FCancelando);

	if FDescargando then
		MessageBox(Handle, 'No puedes salir de la aplicación mientras se está descargando.', PChar(Caption), MB_ICONINFORMATION)
	else if FCancelando then
		MessageBox(Handle, 'No puedes salir de la aplicación mientras se está cancelando la descarga.', PChar(Caption), MB_ICONINFORMATION);
end;


end.
