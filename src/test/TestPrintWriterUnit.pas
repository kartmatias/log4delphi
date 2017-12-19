unit TestPrintWriterUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  Classes,
{$ifdef fpc}
  fpcunit, testutils, testregistry,
{$else}
  TestFramework,
{$endif}
  TPrintWriterUnit;

type
   TTestPrintWriter = class (TTestCase)
  private
    FWriter : TPrintWriter;
    FStream : TStringStream;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestPrint;
    procedure TestPrintln;
  end;

implementation

procedure TTestPrintWriter.Setup;
begin
  FStream := TStringStream.Create('');
  FWriter := TPrintWriter.Create(FStream);
end;

procedure TTestPrintWriter.TearDown;
begin
  FWriter.Free;
  FStream.Free;
end;

procedure TTestPrintWriter.TestCreate;
begin
  Check(FWriter <> Nil, 'Writer cannot be nil.');
end;

procedure TTestPrintWriter.TestPrint;
begin
  FWriter.Print('abc');
  Check(FStream.DataString = 'abc', 'Output is incorrect.');  
end;

procedure TTestPrintWriter.TestPrintln;
begin
  FWriter.Println('def');
  Check(FStream.DataString = 'def' + #13#10, 'Output is incorrect.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestPrintWriter)
{$else}
  TestFramework.RegisterTest(TTestPrintWriter.Suite)
{$endif}

end.
 