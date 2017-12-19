unit TestLoggingEventUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
{$ifdef fpc}
  fpcunit, testutils, testregistry,
{$else}
  TestFramework,
{$endif}
   TLoggingEventUnit;

type
  TTestLoggingEvent = class (TTestCase)
  private
    FEvent : TLoggingEvent;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLevel;
    procedure TestMessage;
    procedure TestStartTime;
    procedure TestException;
    procedure TestLogger;
  end;

implementation

uses
  SysUtils,
  TLevelUnit;

procedure TTestLoggingEvent.Setup;
begin
  FEvent := TLoggingEvent.Create(TLevelUnit.DEBUG, 'A debug message.', 'ROOT');
end;

procedure TTestLoggingEvent.TearDown;
begin
  FEvent.Free;
end;

procedure TTestLoggingEvent.TestCreate;
begin
  Check(FEvent <> Nil, 'Event cannot be nil.');
end;

procedure TTestLoggingEvent.TestLevel;
begin
  Check(FEvent.GetLevel = TLevelUnit.DEBUG, 'Level should be DEBUG.');
end;

procedure TTestLoggingEvent.TestMessage;
begin
  Check(FEvent.GetMessage = 'A debug message.', 'Message is incorrect.');
end;

procedure TTestLoggingEvent.TestStartTime;
var
  hour, min, eHour, eMin, s, m : Word;
begin
  DecodeTime(now,hour,min,s,m);
  DecodeTime(FEvent.GetStartTime,eHour,eMin,s,m);
  Check(hour = eHour);
  Check(min = eMin);
end;

procedure TTestLoggingEvent.TestException;
var
  ex : Exception;
begin
  ex := Exception.create('Exception message');
  FEvent.Free;
  FEvent := TLoggingEvent.Create(TLevelUnit.DEBUG, 'A debug message.', 'ROOT', ex);
  Check(FEvent.GetException = ex, 'Exception is incorrect.');
end;

procedure TTestLoggingEvent.TestLogger;
begin
  Check(FEvent.GetLogger = 'ROOT', 'Logger is incorrect.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestLoggingEvent)
{$else}
  TestFramework.RegisterTest(TTestLoggingEvent.Suite)
{$endif}

end.
 