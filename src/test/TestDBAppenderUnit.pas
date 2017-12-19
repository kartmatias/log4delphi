unit TestDBAppenderUnit;

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
  TDBAppenderUnit, TDBLogInserterUnit, TLoggingEventUnit;

type

   TNullLogInserter = class (TDBLogInserter)
   protected
     appended : Boolean;
     procedure Insert(AEvent : TLoggingEvent); Override;
   public
     constructor Create;
     function isAppended : Boolean;
   end;

   TTestDBAppender = class (TTestCase)
   protected
     appender : TDBAppender;
     inserter : TNullLogInserter;
   public
    procedure Setup; override;
    procedure TearDown; override;
   published
     procedure TestCreate;
     procedure TestAppend;
   end;

implementation

uses
  TLevelUnit;

constructor TNullLogInserter.Create;
begin
  appended := false;
end;

procedure TNullLogInserter.Insert(AEvent : TLoggingEvent);
begin
  appended := true;
end;

function TNullLogInserter.isAppended : Boolean;
begin
  result := appended;
end;

procedure TTestDBAppender.Setup;
begin
  inserter := TNullLogInserter.Create;
  appender := TDBAppender.Create(inserter);
end;

procedure TTestDBAppender.TearDown;
begin
  appender.Free;
end;

procedure TTestDBAppender.TestCreate;
begin
  Check(Appender <> Nil, 'Appender cannot be Nil');
end;

procedure TTestDBAppender.TestAppend;
var
  event : TLoggingEvent;
begin
  event := TLoggingEvent.Create(TLevelUnit.DEBUG,'Debug message','ROOT');
  appender.Append(event);
  check(inserter.isAppended, 'Append failed for appender');
  event.Free;
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestDBAppender)
{$else}
  TestFramework.RegisterTest(TTestDBAppender.Suite)
{$endif}

end.
 