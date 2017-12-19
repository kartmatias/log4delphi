unit TTestIBXLogInserterUnit;

interface

uses
   IBDatabase, TestFrameWork, TIBXLogInserterUnit, TLoggingEventUnit;

type
   TTestIBXLogInserter = class (TTestCase)
   protected
     inserter : TIBXLogInserter;
     db : TIBDatabase;
     transaction : TIBTransaction;
   public
    procedure Setup; override;
    procedure TearDown; override;
   published
     procedure TestCreate;
     procedure TestAppend;
   end;

implementation

uses
  Forms, SysUtils, Dialogs, TLevelUnit, IBSQL, TConfiguratorUnit;

procedure TTestIBXLogInserter.Setup;
begin
   TConfiguratorUnit.doBasicConfiguration;
    transaction := TIBTransaction.Create(Nil);
    db := TIBDatabase.Create(Nil);
    db.DefaultTransaction := transaction;
    db.DatabaseName := ExtractFileDir(Application.ExeName) + '\test.fdb';
    db.SQLDialect := 3;
    db.LoginPrompt := false;
    db.Params.Add('user_name=sysdba');
    db.Params.Add('password=masterkey');
    db.Connected := true;
    transaction.StartTransaction;
    inserter := TIBXLogInserter.Create(db,'insert into Log(log_level,log_message,log_starttime,log_exception) values(:_level,:_msg,:_startTime,:_exception)');
end;

procedure TTestIBXLogInserter.TearDown;
begin
  transaction.Commit;
  db.Connected := false;
  inserter.Free;
  db.Free;
  transaction.Free;
end;

procedure TTestIBXLogInserter.TestCreate;
begin
  Check(inserter <> Nil, 'Inserter cannot be Nil.');
end;

procedure TTestIBXLogInserter.TestAppend;
var
  event : TLoggingEvent;
  ex : Exception;
  sql : TIBSQL;
begin
  sql := TIBSQL.Create(Nil);
  sql.Database := db;
  ex := Exception.Create('Ex message');
  event := TLoggingEvent.Create(TLevelUnit.DEBUG,'A debug message','ROOT',ex);
  inserter.Insert(event);
  transaction.Commit;
  transaction.StartTransaction;
  sql.SQL.Text := 'SELECT * FROM Log';
  sql.ExecQuery;
  Check(sql.fieldbyname('log_level').AsString = 'DEBUG', 'Log message is not correct.');
  Check(sql.fieldbyname('log_message').AsString = 'A debug message', 'Log message is not correct.');
  Check(sql.fieldbyname('log_exception').AsString = 'Ex message', 'Log message is not correct.');
  sql.Close;
  sql.SQL.Text := 'DELETE FROM Log';
  sql.ExecQuery;
  sql.Close;
  sql.Free;
  event.Free;
end;

initialization
   TestFramework.RegisterTest(TTestIBXLogInserter.Suite);

end.
 