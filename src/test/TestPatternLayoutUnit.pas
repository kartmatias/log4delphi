unit TestPatternLayoutUnit;

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
  TPatternLayoutUnit;

type
  TTestPatternLayout = class (TTestCase)
  private
    FLayout : TPatternLayout;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestFormat;
    procedure TestIgnoresException;
  end;

implementation

uses
  SysUtils,
  TLoggingEventUnit, TLevelUnit;

procedure TTestPatternLayout.Setup;
begin
  FLayout := TPatternLayout.Create;
end;

procedure TTestPatternLayout.TearDown;
begin
  FLayout.Free;
end;

procedure TTestPatternLayout.TestCreate;
begin
  Check(FLayout <> Nil, 'Layout cannot be nil.');
end;

procedure TTestPatternLayout.TestFormat;
var
  Format : String;
  event : TLoggingEvent;
begin
  event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'Test message', 'ROOT');
  format := FormatDateTime('dd mmm yyyy hh:nn:ss:zzz',event.GetStartTime)
    + ' [' + event.GetLevel.ToString + '] ' + event.GetLogger + ': '
    + event.GetMessage + #13;
  FLayout :=
    TPatternLayout.Create('%d{dd mmm yyyy hh:nn:ss:zzz} [%p] %L: %m%n');
  Check(FLayout.Format(event) = Format, 'Format string is not correct.');
  event.Free;
end;

procedure TTestPatternLayout.TestIgnoresException;
begin
  Check(not FLayout.IgnoresException, 'Layout should not ignore exceptions.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestPatternLayout)
{$else}
  TestFramework.RegisterTest(TTestPatternLayout.Suite)
{$endif}

end.
 