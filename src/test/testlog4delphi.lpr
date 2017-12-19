program testlog4delphi;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

uses
  Interfaces, Forms, GuiTestRunner, LResources,
  TestAppenderUnit in 'testappenderunit.pas',
  TestFileAppenderUnit in 'testfileappenderunit.pas',
  TestDBAppenderUnit in 'testdbappenderunit.pas',
  TestHTMLLayoutUnit in 'testhtmllayoutunit.pas',
  TestLayoutUnit in 'testlayoutunit.pas',
  TestLevelUnit in 'testlevelunit.pas',
  TestLoggerUnit in 'testloggerunit.pas',
  TestLoggingEventUnit in 'testloggingeventunit.pas',
  TestLogLogUnit in 'testloglogunit.pas',
  TestOnlyOnceErrorHandlerUnit in 'testonlyonceerrorhandlerunit.pas',
  TestPatternLayoutUnit in 'testpatternlayoutunit.pas',
  TestPrintWriterUnit in 'testprintwriterunit.pas',
  TestPropertiesUnit in 'testpropertiesunit.pas',
  TestSimpleLayoutUnit in 'testsimplelayoutunit.pas',
  TestWriterAppenderUnit in 'testwriterappenderunit.pas',
  TestXMLLayoutUnit in 'testxmllayoutunit.pas',
  TestStringUnit in 'teststringunit.pas';

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.
