unit login;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TLoginFrm = class(TForm)
    e_user: TEdit;
    e_pass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
  private
    function GetUsername: string;
    function GetPassword: string;
  public
    property username: string read GetUsername;
    property password: string read GetPassword;
  end;

implementation

{$R *.DFM}

function TLoginFrm.GetUsername: string;
begin
	result := e_user.text;
end;

function TLoginFrm.GetPassword: string;
begin
	result := e_pass.text;
end;


end.
