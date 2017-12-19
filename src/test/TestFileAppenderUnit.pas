unit TestFileAppenderUnit;

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
  TFileAppenderUnit;

type
   TTestFileAppender = class (TTestCase)
   published
     procedure TestCreate;
     procedure TestCreateFile;
     procedure TestCreateFileAndLayout;
     procedure TestCreateFileLayoutAndAppend;
     procedure TestFile;
     procedure TestLayout;
   end;

implementation

uses
  SysUtils, Forms,
  TSimpleLayoutUnit, TLoggingEventUnit, TLevelUnit;

procedure TTestFileAppender.TestCreate;
var
  appender : TFileAppender;
begin
  appender := TFileAppender.Create;
  Check(appender <> Nil, 'Appender should not be nil.');
  appender.Append(nil);
  appender.Free;
end;

procedure TTestFileAppender.TestCreateFile;
var
  appender : TFileAppender;
  event : TLoggingEvent;
begin
  event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'A test debug message',
    'ROOT');
  appender := TFileAppender.Create(ExtractFileDir(Application.ExeName)
    + '\TestFileAppender1.log');
  Check(appender <> Nil, 'Appender should not be nil.');
  appender.Append(event);
  Check(appender.GetLayout.ClassName = 'TSimpleLayout',
    'Appender should have TSimpleLayout.');
  appender.Free;
  event.Free;
end;

procedure TTestFileAppender.TestCreateFileAndLayout;
var
  appender : TFileAppender;
  event : TLoggingEvent;
  layout : TSimpleLayout;
begin
  layout := TSimpleLayout.Create;
  event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'A test debug message',
    'ROOT');
  appender := TFileAppender.Create(ExtractFileDir(Application.ExeName) +
    '\TestFileAppender1.log', layout);
  Check(appender <> Nil, 'Appender should not be nil.');
  appender.Append(event);
  Check(appender.GetLayout.ClassName = 'TSimpleLayout',
    'Appender should have TSimpleLayout.');
  appender.Free;
  event.Free;
end;

procedure TTestFileAppender.TestCreateFileLayoutAndAppend;
var
  appender : TFileAppender;
  event : TLoggingEvent;
  layout : TSimpleLayout;
begin
  layout := TSimpleLayout.Create;
  event := TLoggingEvent.Create(TLevelUnit.DEBUG, 'Another test debug message',
    'ROOT');
  appender := TFileAppender.Create(ExtractFileDir(Application.ExeName) +
    '\TestFileAppender1.log', layout, true);
  Check(appender <> Nil, 'Appender should not be nil.');
  appender.Append(event);
  Check(appender.GetLayout.ClassName = 'TSimpleLayout',
    'Appender should have TSimpleLayout.');
  appender.Free;
  event.Free;
end;

procedure TTestFileAppender.TestFile;
var
  appender : TFileAppender;
begin
  appender := TFileAppender.Create;
  Check(appender <> Nil, 'Appender should not be nil.');
  appender.SetFile(ExtractFileDir(Application.ExeName) +
    '\TestFileAppender2.log');
  Check(FileExists(ExtractFileDir(Application.ExeName) +
    '\TestFileAppender2.log'), 'File should exist!');
  appender.Free;
end;

procedure TTestFileAppender.TestLayout;
var
  appender : TFileAppender;
  layout : TSimpleLayout;
begin
  layout := TSimpleLayout.Create;
  appender := TFileAppender.Create;
  Check(appender <> Nil, 'Appender should not be nil.');
  appender.setLayout(layout);
  Check(appender.GetLayout.ClassName = 'TSimpleLayout',
    'Appender should have TSimpleLayout.');  
  appender.Free;
end;

initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestFileAppender)
{$else}
  TestFramework.RegisterTest(TTestFileAppender.Suite)
{$endif}

end.
 