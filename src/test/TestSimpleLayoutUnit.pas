unit TestSimpleLayoutUnit;

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
  TSimpleLayoutUnit;

type
   TTestSimpleLayout = class (TTestCase)
  private
    FLayout : TSimpleLayout;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure testLayoutCreate();
    procedure testLayoutFormat();
  end;

implementation

uses
  TLevelUnit, TLoggingEventUnit;

procedure TTestSimpleLayout.Setup;
begin
  FLayout := TSimpleLayout.Create;
end;

procedure TTestSimpleLayout.TearDown;
begin
  FLayout.Free;
end;

procedure TTestSimpleLayout.testLayoutCreate();
begin
   Check(FLayout <> Nil, 'Layout should not be nil.');
end;

procedure TTestSimpleLayout.testLayoutFormat();
var
   event : TLoggingEvent;
begin
   event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'msg', 'A Logger');
   Check(FLayout.format(event) = 'DEBUG - msg', 'Formatted event not correct');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestSimpleLayout)
{$else}
  TestFramework.RegisterTest(TTestSimpleLayout.Suite)
{$endif}

end.
 