//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: Ejecutar.pas
//
// Propósito:
//		Frame para la ejecución de funciones. Este frame simplifica el código de main.pas
//
// Autor:          José Manuel Navarro (jose_manuel_navarro@yahoo.es)
// Fecha:          01/04/2003
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 14 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

unit Ejecutar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActnList;

type
  TEjecutarFrame = class(TFrame)
    p_pie: TPanel;
    l_retorno: TLabel;
    b_ejecutar: TButton;
    l_retorno2: TLabel;
    Bevel1: TBevel;
    procedure Execute(Sender: TObject);
  private
    FAccion: TCustomAction;

  public
    procedure Init(accion: TCustomAction);
  end;

implementation

uses main;

{$R *.DFM}


procedure TEjecutarFrame.Init(accion: TCustomAction);
begin
   FAccion := accion;
end;



procedure TEjecutarFrame.Execute(Sender: TObject);
begin
   FAccion.Execute();

   // el evento OnExecute me guarda en el tag el código de error
   if FAccion.Tag = 1 then
   begin
      l_retorno.caption := 'Correcto';
      l_retorno.Font.Color := clGreen;
      l_retorno.Hint := '';
      l_retorno.ShowHint := false;
   end
   else if FAccion.Tag <> 0 then
   begin
      l_retorno.caption := 'Error: ' + SysErrorMessage(FAccion.Tag);
      l_retorno.Hint := l_retorno.caption;
      l_retorno.ShowHint := true;
      l_retorno.Font.Color := clRed;
   end;
end;

end.

