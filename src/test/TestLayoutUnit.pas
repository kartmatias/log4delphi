unit TestLayoutUnit;

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
  TLayoutUnit;

type
  TTestLayout = class (TTestCase)
  private
    FLayout : TLayout;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestContentType;
    procedure TestHeader;
    procedure TestFooter;
    procedure TestIgnoresException;
  end;

implementation

procedure TTestLayout.Setup;
begin
  FLayout := TLayout.Create;
end;

procedure TTestLayout.TearDown;
begin
  FLayout.Free;
end;

procedure TTestLayout.TestCreate;
begin
  Check(FLayout <> Nil, 'Layout cannot be nil.');
end;

procedure TTestLayout.TestContentType;
begin
  Check(FLayout.GetContentType = 'text/plain', 'Content type is incorrect.');
end;

procedure TTestLayout.TestHeader;
begin
  Check(FLayout.GetHeader = '', 'Header is incorrect.');
end;

procedure TTestLayout.TestFooter;
begin
  Check(FLayout.GetFooter = '', 'Footer is incorrect.');
end;

procedure TTestLayout.TestIgnoresException;
begin
  Check(Flayout.IgnoresException, 'Layout should ignore exception.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestLayout)
{$else}
  TestFramework.RegisterTest(TTestLayout.Suite)
{$endif}

end.
 