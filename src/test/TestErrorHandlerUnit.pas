unit TestErrorHandlerUnit;

interface

uses
   TestFrameWork, TErrorHandlerUnit, TOnlyOnceErrorHandlerUnit, TLoggerUnit,
   TConfiguratorUnit;

type
   TTestErrorHandler = class (TTestCase)
   published
      procedure testCreate;
      procedure testError;
   end;


implementation

procedure TTestErrorHandler.testCreate;
var
   handler : TErrorHandler;
begin
   TConfiguratorUnit.doBasicConfiguration;
   handler := TOnlyOnceErrorHandler.Create;
   Check(handler <> Nil, 'Handler cannot be nil.');
   TLogger.freeInstances;
end;

procedure TTestErrorHandler.testError;
var
   handler : TErrorHandler;
begin
   TConfiguratorUnit.doBasicConfiguration;
   handler := TOnlyOnceErrorHandler.Create;
   handler.error('Handler test error message');
   TLogger.freeInstances;
end;

initialization
   TestFramework.RegisterTest(TTestErrorHandler.Suite);

end.
 