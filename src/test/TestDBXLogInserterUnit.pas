unit TestDBXLogInserterUnit;

interface

uses
   SqlExpr, TestFrameWork, TDBXLogInserterUnit, TLoggingEventUnit;

type
   TTestDBXLogInserter = class (TTestCase)
   protected
     inserter : TDBXLogInserter;
     conn : TSQLConnection;
   public
    procedure Setup; override;
    procedure TearDown; override;
   published
     procedure TestCreate;
     procedure TestAppend;
   end;

implementation

uses
  Forms, SysUtils, Dialogs, TLevelUnit, TConfiguratorUnit;

procedure TTestDBXLogInserter.Setup;
begin
  TConfiguratorUnit.doBasicConfiguration;
  conn := TSQLCOnnection.Create(Nil);
  conn := TSQLConnection.Create(Nil);
  conn.LoginPrompt := false;
  conn.ConnectionName := 'IBLocal';
  conn.DriverName := 'Interbase';
  conn.GetDriverFunc := 'getSQLDriverINTERBASE';
  conn.LibraryName := 'dbexpint.dll';
  conn.Params.Add('BlobSize=-1');
  conn.Params.Add('CommitRetain=False');
  conn.Params.Add('Database='+ExtractFileDir(Application.ExeName) + '\test.fdb');
  conn.Params.Add('DriverName=Interbase');
  conn.Params.Add('LocaleCode=0000');
  conn.Params.Add('Password=masterkey');
  conn.Params.Add('RoleName=RoleName');
  conn.Params.Add('SQLDialect=1');
  conn.Params.Add('Interbase TransIsolation=ReadCommited');
  conn.Params.Add('User_Name=sysdba');
  conn.Params.Add('WaitOnLocks=True');
  conn.VendorLib := 'GDS32.DLL';
  conn.Connected := true;  
  inserter := TDBXLogInserter.Create(conn, 'INSERT INTO Log (log_level,log_message,log_starttime,log_exception) values(:_level,:_msg,:_startTime,:_exception)');
end;

procedure TTestDBXLogInserter.TearDown;
begin
  conn.Connected := false;
  inserter.Free;
  conn.Free;
end;

procedure TTestDBXLogInserter.TestCreate;
begin
  Check(inserter <> Nil, 'Inserter cannot be Nil.');
end;

procedure TTestDBXLogInserter.TestAppend;
var
  event : TLoggingEvent;
  ex : Exception;
  sql : TSQLQuery;
begin
  sql := TSQLQuery.Create(Nil);
  sql.SQLConnection := conn;
  ex := Exception.Create('Ex message');
  event := TLoggingEvent.Create(TLevelUnit.DEBUG,'A debug message','ROOT',ex);
  inserter.Insert(event);
  sql.SQL.Text := 'SELECT * FROM Log';
  sql.Open;
  Check(sql.fieldbyname('log_level').AsString = 'DEBUG', 'Log message is not correct.');
  Check(sql.fieldbyname('LOG_MESSAGE').AsString = 'A debug message', 'Log message is not correct.');
  Check(sql.fieldbyname('log_exception').AsString = 'Ex message', 'Log message is not correct.');
  sql.Close;
  sql.SQL.Text := 'DELETE FROM Log';
  sql.ExecSQL(true);
  sql.Close;
  sql.Free;
  event.Free;
end;

initialization
   TestFramework.RegisterTest(TTestDBXLogInserter.Suite);

end.

