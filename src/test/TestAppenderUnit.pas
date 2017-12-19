unit TestAppenderUnit;

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
  TAppenderUnit;

type
  TTestAppender = class (TTestCase)
  private
    FAppender : IAppender;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestSetLayout;
    procedure TestSetName;
    procedure TestSetThreshold;
    procedure TestSetErrorHandler;
    procedure TestSevereAs;
    procedure TestRequiresLayout;
  end;

implementation

uses
  TSimpleLayoutUnit, TLevelUnit, TOnlyOnceErrorHandlerUnit;

procedure TTestAppender.Setup;
begin
  FAppender := TAppender.Create;
end;

procedure TTestAppender.TearDown;
begin
  FAppender := nil;
end;

procedure TTestAppender.TestCreate;
begin
  Check(FAppender <> Nil, 'Appender cannot be nil.');
end;

procedure TTestAppender.TestSetLayout;
var
  layout : TSimpleLayout;
begin
  layout := TSimpleLayout.Create;
  FAppender.SetLayout(layout);
  check(FAppender.GetLayout <> Nil, 'Layout should not be nil');
  check(FAppender.GetLayout.ClassName = 'TSimpleLayout',
    'Layout should be TSimpleLayout');
end;

procedure TTestAppender.TestSetName;
begin
  FAppender.SetName('Test Appender');
  check(FAppender.GetName = 'Test Appender',
    'Appenders name should be "Test Appender".');
end;

procedure TTestAppender.TestSetThreshold;
begin
  FAppender.SetThreshold(TLevelUnit.INFO);
  Check(FAppender.GetThreshold = TLevelUnit.INFO,
    'Appenders threshold should be INFO.');
  Check(FAppender.GetThreshold.ToString = 'INFO',
    'Appenders threshold should be INFO.');
end;

procedure TTestAppender.TestSetErrorHandler;
var
  errorHandler : TOnlyOnceErrorHandler;
begin
  errorHandler := TOnlyOnceErrorHandler.Create;
  FAppender.SetErrorHandler(errorHandler);
  check(FAppender.GetErrorHandler = errorHandler,
    'Appenders error handler not set correctly.');
  check(FAppender.GetErrorHandler.ClassName = 'TOnlyOnceErrorHandler',
    'Appenders error handler not set correctly.');
end;

procedure TTestAppender.TestSevereAs;
begin
  FAppender.SetThreshold(TLevelUnit.INFO);
  Check(not FAppender.IsAsSevereAsThreshold(TLevelUnit.DEBUG),
    'Should not be as severe as DEBUG.');
  Check(FAppender.IsAsSevereAsThreshold(TLevelUnit.FATAL),
    'Should not be as severe as FATAL.');
end;

procedure TTestAppender.TestRequiresLayout;
begin
  Check(not FAppender.RequiresLayout,
    'Default appender should not require a layout.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestAppender);
{$else}
  TestFramework.RegisterTest(TTestAppender.Suite);
{$endif}

end.
 
