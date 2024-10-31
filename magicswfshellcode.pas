unit magicswfshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, LazFileUtils;

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
  private
    { private declarations }
  public
    { public declarations }
  end; 

var Form1: TForm1;

implementation

function get_projector(): string;
begin
 get_projector:=ExtractFilePath(Application.ExeName)+'flashplayer_32_sa.exe';
end;

function get_compiler(): string;
begin
 get_compiler:=ExtractFilePath(Application.ExeName)+'magicswf.exe';
end;

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 execute_program:=code;
end;

procedure window_setup();
begin
 Application.Title:='Magic swf shell';
 Form1.Caption:='Magic swf shell 0.3.7';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
 Form1.OpenDialog1.FileName:='*.swf';
 Form1.OpenDialog1.DefaultExt:='*.swf';
 Form1.OpenDialog1.Filter:='Adobe Flash movies|*.swf';
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

procedure language_setup();
begin
 Form1.LabeledEdit1.EditLabel.Caption:='Target file';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Start';
 Form1.OpenDialog1.Title:='Open an Adobe Flash movie';
end;

procedure setup();
begin
 window_setup();
 interface_setup();
 dialog_setup();
 language_setup();
end;

function compile_flash(const target:string):string;
var status,player,argument:string;
var information:array[0..5] of string=('Operation was successfully complete','Cant open the input file','Cant create the output file','Cant allocate memory','The executable file of the Flash Player Projector was corrupted','The Flash movie was corrupted');
var id:Integer;
begin
 status:='Can not execute an external program';
 player:=get_projector();
 argument:=convert_file_name(player)+' '+convert_file_name(target);
 id:=execute_program(get_compiler(),argument);
 if id>=0 then
 begin
  status:=information[id];
 end;
 compile_flash:=status;
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

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Form1.OpenDialog1.Execute()=True then Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 ShowMessage(compile_flash(Form1.LabeledEdit1.Text));
end;

{$R *.lfm}

end.
