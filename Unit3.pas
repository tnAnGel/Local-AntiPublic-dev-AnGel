unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, UniProvider, SQLiteUniProvider, DBAccess, Uni, Data.DB, CREncryption,
  MemDS;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Image1: TImage;
    Image2: TImage;
    LabeledEdit1: TLabeledEdit;
    procedure Image1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Form1.Enabled:=True;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
 Form1.Enabled:=False;
end;

procedure TForm3.Image1Click(Sender: TObject);
var Connect: TUniConnection;
    SQL: TUniQuery;
    email, password: string;
    i: integer;
begin
 SQL:=TUniQuery.Create(nil);
 Connect:=TUniConnection.Create(nil);
 Connect.ProviderName:='SQLite';
 Connect.Database:=ExtractFilePath(ParamStr(0))+'antipublic.db';
 Connect.Connect;
 Connect.ExecSQL('PRAGMA page_size = 65536');
 Connect.ExecSQL('PRAGMA synchronous = 0');
 Connect.ExecSQL('PRAGMA journal_mode = OFF');
 Connect.ExecSQL('PRAGMA temp_store = MEMORY'); // FILE  MEMORY
// Connect.ExecSQL('PRAGMA auto_vacuum = FULL');
 Connect.ExecSQL('PRAGMA auto_vacuum = FULL');
 Connect.ExecSQL('PRAGMA cache_size = 256000');
 SQL.Connection:=Connect;

 SQL.SQL.Clear;
 SQL.SQL.Text:='SELECT * FROM data WHERE email = :email';
 SQL.Params[0].AsString:=Form3.LabeledEdit1.Text;
 SQL.Open;

 Form3.Memo1.Lines.Clear;
 if SQL.RecordCount <> 0 then
 begin
  for I:=0 to SQL.RecordCount-1 do
  begin
   email:=SQL.Fields[0].AsString;
   password:=SQL.Fields[1].AsString;
   SQL.FindNext;
   Form3.Memo1.Lines.Add(email+':'+password);
  end;
 end else Form3.Memo1.Lines.Add('??? ??????');


 FreeAndNil(SQL);
 FreeAndNil(Connect);
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
 Form3.Close;
 Form1.Enabled:=True;
end;

end.
