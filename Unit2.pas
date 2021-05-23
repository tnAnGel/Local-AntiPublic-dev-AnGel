unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, UniProvider, SQLiteUniProvider, DBAccess, Uni, Data.DB, CREncryption,
  MemDS, Winapi.ShellAPI, Vcl.Imaging.pngimage;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Check: Integer;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Form1.Enabled:=True;
 Form2.Close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 Form1.Enabled:=False;
end;

procedure TForm2.Image1Click(Sender: TObject);
var Connect: TUniConnection;
    buttonSelected: Integer;
begin
 Connect:=TUniConnection.Create(nil);
 Connect.ProviderName:='SQLite';
 Connect.Database:=ExtractFilePath(ParamStr(0))+'antipublic.db';
 Connect.SpecificOptions.Values['ForceCreateDatabase'] := 'True';
 Connect.SpecificOptions.Values['Direct'] := 'True';
 Connect.Open;
 Connect.ExecSQL('CREATE TABLE data (email TEXT, password TEXT);');

 case Check of
  0: Connect.ExecSQL('CREATE INDEX EPH ON data (email);');
  1: Connect.ExecSQL('CREATE INDEX EPH ON data (email, password);');
 end;
 Unit1.TypeIndex:=Check;

 Connect.ExecSQL('PRAGMA page_size = 65536');
 Connect.ExecSQL('PRAGMA synchronous = OFF');
 Connect.ExecSQL('PRAGMA journal_mode = OFF');
 Connect.ExecSQL('PRAGMA temp_store = MEMORY'); // FILE  MEMORY
 // Connect.ExecSQL('PRAGMA auto_vacuum = FULL');
 Connect.ExecSQL('PRAGMA auto_vacuum = FULL');
 Connect.ExecSQL('PRAGMA cache_size = 256000');
 FreeAndNil(Connect);

 buttonSelected := MessageDlg('���� ������ �������, ���������� ����� ������������.', mtInformation, [mbOk], 0);
 if buttonSelected = mrOK then
 begin
  ShellExecute(Self.Handle, nil, PChar(Application.ExeName), nil, nil, SW_SHOW);
  Application.Terminate;
 end;
end;

procedure TForm2.Image2Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm2.Image3Click(Sender: TObject);
begin
 ShellExecute(handle, 'open', 'https://dark-time.com/threads/36155/', nil, nil, SW_SHOW);
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
begin
 Check:=0;
end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
 Check:=1;
end;

procedure TForm2.RadioButton3Click(Sender: TObject);
begin
 Check:=1;
end;

end.
