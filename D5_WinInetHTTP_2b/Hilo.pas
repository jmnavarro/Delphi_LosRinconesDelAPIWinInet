//---------------------------------------------------------------------------------------------
//
// Archivo: Hilo.pas
//
// Propósito:
//    Implementación de un objeto "Thread" a través de las funciones del API Win32, sin 
//    la clase TThread de la VCL.
//
// Autor:          José Manuel Navarro - http://www.lawebdejm.com
// Fecha:          01/05/2004
// Observaciones:  Unidad creada en Delphi 5.
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//---------------------------------------------------------------------------------------------
unit Hilo;

interface

uses Windows;

type
	THilo = class(TObject)
	private
		hHilo: THandle;
		idHilo: DWORD;

		FCancelado: boolean;

	protected
		function funcionHilo: DWORD; virtual;

	public
		constructor Create;
		destructor Destroy; override;

		procedure pausar;
		procedure arrancar;
		procedure iniciar(parado: boolean);
		function esperarHastaQueMuera(timeout: DWORD = INFINITE): boolean;

		property Cancelado: boolean read FCancelado write FCancelado;
	end;


implementation


function _funcionHilo(param: Pointer): DWORD; stdcall;
var
	obj: THilo;
begin
	obj := THilo(param);

	result := obj.funcionHilo;
end;


constructor THilo.Create;
begin
	inherited;


end;


destructor THilo.Destroy;
begin
	hHilo  := 0;
	idHilo := 0;

	FCancelado := false;

	inherited;
end;


procedure THilo.pausar;
begin
	SuspendThread(hHilo);
end;


procedure THilo.arrancar;
begin
	ResumeThread(hHilo);
end;


procedure THilo.iniciar(parado: boolean);
var
	flag: DWORD;
	proc: TFNThreadStartRoutine;
begin
	if parado then
		flag := CREATE_SUSPENDED
	else
		flag := 0;

	proc := @_funcionHilo;

	hHilo := CreateThread(nil, 0, proc, Self, flag, idHilo);
end;


function THilo.esperarHastaQueMuera(timeout: DWORD = INFINITE): boolean;
begin
	result := (WAIT_OBJECT_0 = WaitForSingleObject(hHilo, timeout));
end;


function THilo.funcionHilo: DWORD;
begin
	result := 0;
end;



end.