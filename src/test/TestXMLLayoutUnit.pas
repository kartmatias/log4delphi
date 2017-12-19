unit TestXMLLayoutUnit;

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
  TXMLLayoutUnit;

type
  TTestXMLLayout = class (TTestCase)
  private
    FLayout : TXMLLayout;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestFormat;
    procedure TestContentType;
    procedure TestIgnoresException;
  end;

implementation

uses
  SysUtils,
  TLoggingEventUnit, TLevelUnit;

procedure TTestXMLLayout.Setup;
begin
  FLayout := TXMLLayout.Create;
end;

procedure TTestXMLLayout.TearDown;
begin
  FLayout.Free;
end;

procedure TTestXMLLayout.TestCreate;
begin
  Check(FLayout <> Nil, 'Layout cannot be nil.');
end;

procedure TTestXMLLayout.TestFormat;
var
  format : String;
  event : TLoggingEvent;
begin
  event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'A debug message.', 'ROOT');
  format := '<log4delphi:event timestamp="'
      + IntToStr(DateTimeToFileDate(event.getStartTime))
      + '" level="' + event.GetLevel.toString + '">' + #13#10
      + '    <log4delphi:message><![CDATA[' + event.GetMessage
      + ']]></log4delphi:message>' + #13#10 + '</log4delphi:event>' + #13#10;
  Check(FLayout.Format(event) = format, 'Output is incorrect.');
  event.Free;
end;

procedure TTestXMLLayout.TestContentType;
begin
  Check(FLayout.GetContentType = 'text/xml', 'Content ype is incorrect.');
end;

procedure TTestXMLLayout.TestIgnoresException;
begin
  Check(not FLayout.IgnoresException, 'Layout should not ignore exception.');
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestXMLLayout)
{$else}
  TestFramework.RegisterTest(TTestXMLLayout.Suite)
{$endif}

end.
 