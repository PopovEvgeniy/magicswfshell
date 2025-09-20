unit magicswfshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    StartButton: TButton;
    FileField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    procedure OpenButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileFieldChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

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
 MainWindow.Caption:='Magic swf shell 0.4';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure dialog_setup();
begin
 MainWindow.OpenDialog.FileName:='*.swf';
 MainWindow.OpenDialog.DefaultExt:='*.swf';
 MainWindow.OpenDialog.Filter:='Adobe Flash movies|*.swf';
end;

procedure interface_setup();
begin
 MainWindow.OpenButton.ShowHint:=False;
 MainWindow.StartButton.ShowHint:=MainWindow.OpenButton.ShowHint;
 MainWindow.StartButton.Enabled:=False;
 MainWindow.FileField.Text:='';
 MainWindow.FileField.LabelPosition:=lpLeft;
 MainWindow.FileField.Enabled:=False;
end;

procedure language_setup();
begin
 MainWindow.FileField.EditLabel.Caption:='Target file';
 MainWindow.OpenButton.Caption:='Open';
 MainWindow.StartButton.Caption:='Start';
 MainWindow.OpenDialog.Title:='Open an Adobe Flash movie';
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
var information:array[0..5] of string=('The operation was successfully completed','Cant open the input file','Cant create the output file','Cant allocate memory','The executable file of the Flash Player Projector was corrupted','The Flash movie was corrupted');
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

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 MainWindow.StartButton.Enabled:=MainWindow.FileField.Text<>'';
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then MainWindow.FileField.Text:=MainWindow.OpenDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 ShowMessage(compile_flash(MainWindow.FileField.Text));
end;

{$R *.lfm}

end.
