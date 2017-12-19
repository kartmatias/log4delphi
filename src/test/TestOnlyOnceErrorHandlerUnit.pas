unit TestOnlyOnceErrorHandlerUnit;

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
  TOnlyOnceErrorHandlerUnit;

type
  TTestOnlyOnceErrorHandler = class (TTestCase)
  private
    FHandler : TOnlyOnceErrorHandler;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestError;
    procedure TestErrorWithException;
    procedure TestSetAppender;
  end;

implementation

uses
  SysUtils, Forms,
  TLogLogUnit;

procedure TTestOnlyOnceErrorHandler.Setup;
begin
  TLogLogUnit.initialize(ExtractFileDir(Application.ExeName)
    + '\TestOnlyOnceErrorHandler.log');
  FHandler := TOnlyOnceErrorHandler.Create;
end;

procedure TTestOnlyOnceErrorHandler.TearDown;
begin
  FHandler.Free;
  TLogLogUnit.finalize;
end;

procedure TTestOnlyOnceErrorHandler.TestCreate;
begin
  Check(FHandler <> Nil, 'Handler cannot be nil.');
end;

procedure TTestOnlyOnceErrorHandler.TestError;
begin
  try
    FHandler.Error('A test message');
    Check(true);
  except
    Check(false, 'Failed to call error Method.');
  end;
end;

procedure TTestOnlyOnceErrorHandler.TestErrorWithException;
var
  ex : Exception;
begin
  ex := Exception.Create('A test exception.');
  try
    FHandler.Error('A test message', ex);
    Check(true);
  except
    Check(false, 'Failed to call error method with exception.');
  end;
  ex.Free;
end;

procedure TTestOnlyOnceErrorHandler.TestSetAppender;
begin
  FHandler.SetAppender('TestAppender');
  Check(true);
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestOnlyOnceErrorHandler)
{$else}
  TestFramework.RegisterTest(TTestOnlyOnceErrorHandler.Suite)
{$endif}

end.
 