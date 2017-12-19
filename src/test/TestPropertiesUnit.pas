unit TestPropertiesUnit;

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
  TPropertiesUnit;

type
  TTestProperties = class (TTestCase)
  private
    FProperties : TProperties;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestSetProperty;
    procedure TestRemoveProperty;
    procedure TestSave;
    procedure TestLoad;
    procedure TestClear;
    procedure TestGetProperty;
    procedure TestGetPropertyNames;
    procedure TestSubset;
  end;

implementation

uses
  Classes;

procedure TTestProperties.Setup;
begin
  FProperties := TProperties.Create;
end;

procedure TTestProperties.TearDown;
begin
  FProperties.Free;
end;

procedure TTestProperties.TestCreate;
begin
  Check(FProperties <> Nil, 'Properties cannot be nil.');
end;

procedure TTestProperties.TestSetProperty;
begin
  FProperties.SetProperty('testkey', 'testvalue');
  Check(FProperties.GetProperty('testkey') = 'testvalue',
    'Property is incorrect.');
end;

procedure TTestProperties.TestRemoveProperty;
begin
  FProperties.SetProperty('testkey', 'testvalue');
  FProperties.RemoveProperty('testkey');
  Check(FProperties.GetProperty('testkey') = '', 'Property is incorrect.');
end;

procedure TTestProperties.TestSave;
var
  stream : TStringStream;
begin
  stream := TStringStream.Create('');
  FProperties.SetProperty('testkey', 'testvalue');
  FProperties.Save(stream);
  Check(stream.DataString = 'testkey=testvalue'+#13#10, 'Output not correct.');
  stream.Free;
end;

procedure TTestProperties.TestLoad;
var
  stream : TStringStream;
begin
  stream := TStringStream.Create('testkey=testvalue');
  FProperties.Load(stream);
  Check(FProperties.GetProperty('testkey') = 'testvalue',
    'Property is incorrect.');
  stream.Free;
end;

procedure TTestProperties.TestClear;
begin
  FProperties.SetProperty('testkey', 'testvalue');
  FProperties.Clear;
  Check(FProperties.GetProperty('testkey') = '', 'Property is incorrect.');
end;

procedure TTestProperties.TestGetProperty;
begin
  FProperties.SetProperty('testkey', 'testvalue');
  Check(FProperties.GetProperty('testkey') = 'testvalue',
    'Property is incorrect.');
  Check(FProperties.GetProperty('nonexistantkey','defaultvalue') =
    'defaultvalue', 'Property is incorrect.');
end;

procedure TTestProperties.TestGetPropertyNames;
var
  names : TStrings;
begin
  FProperties.SetProperty('testkey', 'testvalue');
  names := FProperties.GetPropertyNames;
  Check(names[0] = 'testkey', 'Names is incorrect');
  names.Free;
end;

procedure TTestProperties.TestSubset;
var
  subset : TProperties;
begin
  FProperties.SetProperty('test.key1', 'testvalue1');
  FProperties.SetProperty('test.key2', 'testvalue2');
  FProperties.SetProperty('nontest.key1', 'nontestvalue1');
  subset := FProperties.Subset('test');
  Check(subset.GetProperty('test.key1') = 'testvalue1', 'Value 1 is incorrect.');
  Check(subset.GetProperty('test.key2') = 'testvalue2', 'Value 2 is incorrect.');
  subset.Free;    
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestProperties)
{$else}
  TestFramework.RegisterTest(TTestProperties.Suite)
{$endif}

end.
 