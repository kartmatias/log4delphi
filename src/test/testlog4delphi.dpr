program testlog4delphi;

uses
  Forms,
  TestFrameWork,
  TextTestRunner,
  GUITestRunner,
  TestAppenderUnit in 'TestAppenderUnit.pas',
  TestFileAppenderUnit in 'TestFileAppenderUnit.pas',
  TestDBAppenderUnit in 'TestDBAppenderUnit.pas',
  TestIBXLogInserterUnit in 'TestIBXLogInserterUnit.pas',
  TestDBXLogInserterUnit in 'TestDBXLogInserterUnit.pas',
  TestHTMLLayoutUnit in 'TestHTMLLayoutUnit.pas',
  TestLayoutUnit in 'TestLayoutUnit.pas',
  TestLevelUnit in 'TestLevelUnit.pas',
  TestLoggerUnit in 'TestLoggerUnit.pas',
  TestLoggingEventUnit in 'TestLoggingEventUnit.pas',
  TestLogLogUnit in 'TestLogLogUnit.pas',
  TestOnlyOnceErrorHandlerUnit in 'TestOnlyOnceErrorHandlerUnit.pas',
  TestPatternLayoutUnit in 'TestPatternLayoutUnit.pas',
  TestPrintWriterUnit in 'TestPrintWriterUnit.pas',
  TestPropertiesUnit in 'TestPropertiesUnit.pas',
  TestSimpleLayoutUnit in 'TestSimpleLayoutUnit.pas',
  TestWriterAppenderUnit in 'TestWriterAppenderUnit.pas',
  TestXMLLayoutUnit in 'TestXMLLayoutUnit.pas',
  TestStringUnit in 'TestStringUnit.pas';

{$R *.res}

begin
   if (paramCount > 0) then begin
      if (paramStr(1) = '-t') then
         TextTestRunner.RunRegisteredTests
      else
         GUITestRunner.RunRegisteredTests;
   end else
      GUITestRunner.RunRegisteredTests;
end.
