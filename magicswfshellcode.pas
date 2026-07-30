unit magicswfshellcode;

{
 This sofware was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, ComCtrls;

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
    procedure window_setup();
    procedure interface_setup();
    procedure dialog_setup();
    procedure language_setup();
    procedure setup();
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
 Result:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 Result:=code;
end;

function compile_flash(const target:string):string;
var status,player,argument:string;
var information:array[0..8] of string=('The operation was successfully completed','Cannot open the input file','Cannot create the output file','Cannot read data','Cannot write data','Cannot allocate memory','The executable file of the Flash Player projector was corrupted','The Flash movie was corrupted','Cannot get the file size!');
var id:Integer;
begin
 status:='Cannot execute an external program';
 player:=get_projector();
 argument:=convert_file_name(player)+' '+convert_file_name(target);
 id:=execute_program(get_compiler(),argument);
 if id>=0 then
 begin
  status:=information[id];
 end;
 Result:=status;
end;

procedure TMainWindow.window_setup();
begin
 Application.Title:='Magic swf shell';
 Self.Caption:='Magic swf shell 0.4.4';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.dialog_setup();
begin
 Self.OpenDialog.FileName:='*.swf';
 Self.OpenDialog.DefaultExt:='*.swf';
 Self.OpenDialog.Filter:='Adobe Flash movies|*.swf';
end;

procedure TMainWindow.interface_setup();
begin
 Self.OpenButton.ShowHint:=False;
 Self.StartButton.ShowHint:=False;
 Self.StartButton.Enabled:=False;
 Self.FileField.Text:='';
 Self.FileField.LabelPosition:=lpLeft;
 Self.FileField.Enabled:=False;
end;

procedure TMainWindow.language_setup();
begin
 Self.FileField.EditLabel.Caption:='Target file';
 Self.OpenButton.Caption:='Open';
 Self.StartButton.Caption:='Start';
 Self.OpenDialog.Title:='Open an Adobe Flash movie';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.interface_setup();
 Self.dialog_setup();
 Self.language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 Self.StartButton.Enabled:=Self.FileField.Text<>'';
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then Self.FileField.Text:=Self.OpenDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 ShowMessage(compile_flash(Self.FileField.Text));
end;

{$R *.lfm}

end.
