unit TestLoggerUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
{$ifdef fpc}
  fpcunit, testutils, testregistry;
{$else}
  TestFramework;
{$endif}

type
  TTestLogger = class (TTestCase)
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestInstance;
    procedure TestNamedInstance;
    procedure TestLevel;
    procedure TestName;
    procedure TestAddAppender;
    procedure TestRemoveAppender;
    procedure TestRemoveAllAppenders;
    procedure TestGetAppenders;
    procedure TestLog;
    procedure TestMessages;
  end;

implementation

uses
  Classes,
  TLoggerUnit, TLevelUnit, TNullAppenderUnit,
  TWriterAppenderUnit, TSimpleLayoutUnit;

procedure TTestLogger.Setup;
begin
  TLoggerUnit.initialize;
end;

procedure TTestLogger.TearDown;
begin
  TLogger.freeInstances;
end;

procedure TTestLogger.TestInstance;
begin
  Check(TLogger.getInstance <> Nil, 'Root logger cannot be nil');
  Check(TLogger.getInstance.getName = 'ROOT', 'Root logger name is incorrect.');
end;

procedure TTestLogger.TestNamedInstance;
begin
  Check(TLogger.getInstance('test') <> Nil, 'Test logger cannot be nil');
  Check(TLogger.getInstance('test').getName = 'test',
    'Test logger name is incorrect.');  
end;

procedure TTestLogger.TestLevel;
begin
  TLogger.getInstance.setLevel(TLevelUnit.WARN);
  Check(TLogger.getInstance.getLevel = TLevelUnit.WARN, 'Level is incorrect.');
end;

procedure TTestLogger.TestName;
begin
  Check(TLogger.getInstance.getName = 'ROOT', 'Root logger name is incorrect.');
end;

procedure TTestLogger.TestAddAppender;
begin
  TLogger.getInstance.addAppender(TNullAppender.Create);
  Check(TLogger.getInstance.getAppender('TNullAppender') <> Nil,
    'Incorrect appender returned1');
  Check(TLogger.getInstance.getAppender('TNullAppender').ClassName
    = 'TNullAppender', 'Incorrect appender returned2');
end;

procedure TTestLogger.TestRemoveAppender;
begin
  TLogger.getInstance.addAppender(TNullAppender.Create);
  TLogger.getInstance.RemoveAppender('TNullAppender');
  Check(TLogger.getInstance.getAppender('TNullAppender') = Nil,
    'Incorrect appender returned');
end;

procedure TTestLogger.TestRemoveAllAppenders;
begin
  TLogger.getInstance.addAppender(TNullAppender.Create);
  TLogger.getInstance.removeAllAppenders;
  Check(TLogger.getInstance.getAppender('TNullAppender') = Nil,
    'Incorrect appender returned');
end;

procedure TTestLogger.TestGetAppenders;
begin
  TLogger.getInstance.addAppender(TNullAppender.Create);
end;

procedure TTestLogger.TestLog;
var
  appender : TWriterAppender;
  stream : TStringStream;
begin
  stream := TStringStream.Create('');
  appender := TWriterAppender.Create(TSimpleLayout.Create, stream);
  TLogger.getInstance.addAppender(appender);
  TLogger.getInstance.log(TLevelUnit.DEBUG, 'A debug message');
  Check(stream.DataString = 'DEBUG - A debug message' + #13#10, 'Output incorrect.');
  stream.Free;
end;

procedure TTestLogger.TestMessages;
var
  appender : TWriterAppender;
  stream : TStringStream;
  output : String;
begin
  output := 'FATAL - fatal message' + #13#10
    + 'ERROR - error message' + #13#10
    + 'WARN - warn message' + #13#10
    + 'INFO - info message' + #13#10
    + 'DEBUG - debug message' + #13#10 ;
  stream := TStringStream.Create('');
  appender := TWriterAppender.Create(TSimpleLayout.Create, stream);
  TLogger.getInstance.addAppender(appender);
  TLogger.getInstance.fatal('fatal message');
  TLogger.getInstance.error('error message');
  TLogger.getInstance.warn('warn message');
  TLogger.getInstance.info('info message');
  TLogger.getInstance.debug('debug message');
  Check(stream.DataString = output, 'Output incorrect.');
  stream.Free;
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestLogger)
{$else}
  TestFramework.RegisterTest(TTestLogger.Suite)
{$endif}

end.
 