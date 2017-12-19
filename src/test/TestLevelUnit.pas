unit TestLevelUnit;

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
  TTestLevel = class (TTestCase)
  published
    procedure TestEquals;
    procedure TestGreaterThanOrEqual;
    procedure TestToString;
    procedure TestIntValue;
  end;

implementation

uses
  TLevelUnit;

procedure TTestLevel.TestEquals;
begin
  Check(TLevelUnit.DEBUG.Equals(TlevelUnit.DEBUG), 'DEBUG should equal DEBUG');
  Check(not TLevelUnit.DEBUG.Equals(TlevelUnit.INFO),
    'DEBUG should not equal INFO');  
end;

procedure TTestLevel.TestGreaterThanOrEqual;
begin
  Check(TLevelUnit.WARN.isGreaterOrEqual(TLevelUnit.INFO),
    'WARN should be grater than INFO');
  Check(TLevelUnit.INFO.isGreaterOrEqual(TLevelUnit.INFO),
    'INFO should be grater than or equal INFO');
  Check(not TLevelUnit.DEBUG.isGreaterOrEqual(TLevelUnit.INFO),
    'DEBUG should not be grater than INFO');
end;

procedure TTestLevel.TestToString;
begin
  Check(TLevelUnit.OFF.ToString = 'OFF', 'OFF not correct.');
  Check(TLevelUnit.FATAL.ToString = 'FATAL', 'FATAL not correct.');
  Check(TLevelUnit.ERROR.ToString = 'ERROR', 'ERROR not correct.');
  Check(TLevelUnit.WARN.ToString = 'WARN', 'WARN not correct.');
  Check(TLevelUnit.INFO.ToString = 'INFO', 'INFO not correct.');
  Check(TLevelUnit.DEBUG.ToString = 'DEBUG', 'DEBUG not correct.');
  Check(TLevelUnit.TRACE.ToString = 'TRACE', 'DEBUG not correct.');  
  Check(TLevelUnit.ALL.ToString = 'ALL', 'ALL not correct.');
end;

procedure TTestLevel.TestIntValue;
begin
  Check(TLevelUnit.OFF.IntValue = High(Longint), 'OFF not correct.');
  Check(TLevelUnit.FATAL.IntValue = 60000, 'FATAL not correct.');
  Check(TLevelUnit.ERROR.IntValue = 50000, 'ERROR not correct.');
  Check(TLevelUnit.WARN.IntValue = 40000, 'WARN not correct.');
  Check(TLevelUnit.INFO.IntValue = 30000, 'INFO not correct.');
  Check(TLevelUnit.DEBUG.IntValue = 20000, 'DEBUG not correct.');
  Check(TLevelUnit.TRACE.IntValue = 10000, 'TRACE not correct.');
  Check(TLevelUnit.ALL.IntValue = Low(Longint), 'ALL not correct.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestLevel)
{$else}
  TestFramework.RegisterTest(TTestLevel.Suite)
{$endif}

end.
 