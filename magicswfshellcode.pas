unit magicswfshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    LabeledEdit1: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure OpenDialog1CanClose(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var Form1: TForm1;
function get_path(): string;
function convert_file_name(source:string): string;
function execute_program(executable:string;argument:string):Integer;
procedure window_setup();
procedure dialog_setup();
procedure interface_setup();
procedure common_setup();
procedure language_setup();
procedure setup();
procedure compile_flash(target:string);

implementation

function get_path(): string;
begin
 get_path:=ExtractFilePath(Application.ExeName);
end;

function convert_file_name(source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"';
 target:=target+source+'"';
 end;
 convert_file_name:=target;
end;

function execute_program(executable:string;argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  On EOSError do code:=-1;
 end;
 execute_program:=code;
end;

procedure window_setup();
begin
 Application.Title:='Magic swf shell';
 Form1.Caption:='Magic swf shell 0.2.1';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
 Form1.OpenDialog1.FileName:='*.swf';
 Form1.OpenDialog1.DefaultExt:='*.swf';
 Form1.OpenDialog1.Filter:='Adobe flash movies|*.swf';
end;

procedure interface_setup();
begin
 Form1.Button1.ShowHint:=False;
 Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
 Form1.Button2.Enabled:=False;
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit1.Enabled:=False;
end;

procedure common_setup();
begin
 window_setup();
 interface_setup();
 dialog_setup();
end;

procedure language_setup();
begin
 Form1.LabeledEdit1.EditLabel.Caption:='Target file';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Start';
 Form1.OpenDialog1.Title:='Open a Adobe flash movie';
end;

procedure setup();
begin
 common_setup();
 language_setup();
end;

procedure compile_flash(target:string);
var host,player,argument:string;
var message:array[0..5] of string=('Operation was successfully complete','Cant open input file','Cant create output file','Cant allocate memory','Executable file of Flash Player Projector was corrupted','Flash movie was corrupted');
var status:Integer;
begin
 host:=get_path()+'magicswf.exe';
 player:=get_path()+'player.exe';
 argument:=convert_file_name(player)+' '+convert_file_name(target);
 status:=execute_program(host,argument);
 if status=-1 then
 begin
  ShowMessage('Can not execute a external program');
 end
 else
 begin
  ShowMessage(message[status]);
 end;

end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button2.Enabled:=Form1.LabeledEdit1.Text<>'';
end;

procedure TForm1.OpenDialog1CanClose(Sender: TObject; var CanClose: boolean);
begin
 Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Form1.OpenDialog1.Execute();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 compile_flash(Form1.LabeledEdit1.Text);
end;

{$R *.lfm}

end.
