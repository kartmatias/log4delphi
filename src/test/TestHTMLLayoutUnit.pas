unit TestHTMLLayoutUnit;

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
  THTMLLayoutUnit;

type
  TTestHTMLLayout = class (TTestCase)
  private
    FLayout : THTMLLayout;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestTitle;
    procedure TestFormat;
    procedure TestContentType;
    procedure TestHeader;
    procedure TestFooter;
    procedure TestIgnoresException;
  end;

implementation

uses
  SysUtils,
  TLoggingEventUnit, TLevelUnit;

procedure TTestHTMLLayout.Setup;
begin
  FLayout := THTMLLayout.Create;
end;

procedure TTestHTMLLayout.TearDown;
begin
  FLayout.Free;
end;

procedure TTestHTMLLayout.TestCreate;
begin
  Check(FLayout <> Nil, 'Layout cannot be nil.');
end;

procedure TTestHTMLLayout.TestTitle;
begin
  FLayout.SetTitle('Test Title');
  Check(FLayout.GetTitle = 'Test Title', 'Title set incorrectly.');
end;

procedure TTestHTMLLayout.TestFormat;
var
  format : String;
  event : TLoggingEvent;
begin
  event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'A debug message.', 'ROOT');
   format := '                <tr>' + #13#10
   + '                    <td title="Timestamp">'
   + IntToStr(DateTimeToFileDate(event.GetStartTime)) + '</td>' + #13#10
   + '                    <td title="Level" class="' + event.GetLevel.toString
   + '">' + event.GetLevel.toString + '</td>' + #13#10
   + '                    <td title="Message">' + event.GetMessage
   + '</td>' + #13#10
   + '                </tr>' + #13#10;
   Check(FLayout.Format(event) = format, 'Format does not return correct data.');
   event.Free;
end;

procedure TTestHTMLLayout.TestContentType;
begin
  Check(FLayout.GetContentType = 'text/html', 'Content type is incorrect.');
end;

procedure TTestHTMLLayout.TestHeader;
var
  header : String;
begin
  header := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"' + #13#10
   + '    "http://www.w3.org/TR/html4/strict.dtd">' + #13#10
   + '<html>' + #13#10
   + '    <head>' + #13#10
   + '        <title>Log4Delphi Log Messages</title>' + #13#10
   + '        <style type="text/css">' + #13#10
   + '        <!--' + #13#10
   + '            body {background: XFFFFFF; margin: 6px; font-family: arial,sans-serif; font-size: small;}' + #13#10
   + '            table {font-family: arial,sans-serif; font-size: 9pt;}' + #13#10
   + '            th {background: #336699; color: #FFFFFF; text-align: left;}' + #13#10
   + '            td.debug {color: #339933}' + #13#10
   + '            td.warn {color: #FF9229}' + #13#10
   + '            td.error {color: #CC0000}' + #13#10
   + '            td.fatal {color: #FF0000}' + #13#10
   + '        -->' + #13#10
   + '        </style>' + #13#10
   + '    </head>' + #13#10
   + '    <body>' + #13#10
   + '        <p>Log session start time Tue Sep 13 16:19:28 SAST 2005</p>' + #13#10
   + '        <table cellspacing="0" cellpadding="4" width="100%">' + #13#10
   + '            <thead>' + #13#10
   + '                <tr>' + #13#10
   + '                    <th>Time</th>' + #13#10
   + '                    <th>Level</th>' + #13#10
   + '                    <th>Message</th>' + #13#10
   + '                </tr>' + #13#10
   + '            </thead>' + #13#10
   + '            <tbody>' + #13#10;
   Check(FLayout.GetHeader = header, 'Header is incorrect.');
end;

procedure TTestHTMLLayout.TestFooter;
var
  footer : String;
begin
   Footer :=
     '            </tbody>' + #13#10
   + '        </table>' + #13#10
   + '    </body>' + #13#10
   + '</html>' + #13#10;
  Check(FLayout.GetFooter = footer, 'Footer is incorrect.');
end;

procedure TTestHTMLLayout.TestIgnoresException;
begin
  Check(not FLayout.IgnoresException, 'Layout should not ignore exceptions');
end;


initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestHTMLLayout)
{$else}
  TestFramework.RegisterTest(TTestHTMLLayout.Suite)
{$endif}

end.
 