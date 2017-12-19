{
   Copyright 2005-2006 Log4Delphi Project
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
}
{*----------------------------------------------------------------------------
   Contains the TLogLog class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TLogLogUnit;
{$IFDEF fpc}
{$MODE objfpc}
{$H+}
{$ENDIF}
interface
type
   {*----------------------------------------------------------------------------
      This class is used internally to perfrom logging within the Log4Delphi
      package. It is not meant to be used outside the Log4Delphi package.
      Typically statements are logged to a file named 'log4delphi.log'.
     ----------------------------------------------------------------------------}
   TLogLog = class
   public
      class procedure Debug(const AMsg: string);
      class procedure Error(const AMsg: string);
      class procedure Warn(const AMsg: string);
      class procedure Info(const AMsg: string);
      class procedure Fatal(const AMsg: string);
      class procedure SetQuietMode(const AMode: Boolean);
   end;
procedure initialize(const fileName: string);
procedure finalize();
var
   isInit: Boolean = false;
implementation
var
   outFile: TextFile;
   quietMode: Boolean = false;
   {*----------------------------------------------------------------------------
      Initialize the internal logging of Log4Delphi. This method should not be
      called by application developers.
      @param fileName The name of the file to send output to
     ----------------------------------------------------------------------------}
procedure initialize(const fileName: string);
begin
   if isInit then finalize;

   if (not quietMode) then
   begin
      AssignFile(outFile, fileName);
      Rewrite(outFile);
   end;

   isInit := true;
end;
{*----------------------------------------------------------------------------
   Finalize the internal logging by releasing resources. This method should
   not be called by application developers.
  ----------------------------------------------------------------------------}
procedure finalize();
begin
   if ((isInit) and not (quietMode)) then
      CloseFile(outFile);
   isInit := false;
end;
{*----------------------------------------------------------------------------
   Send a debug message.
   @param AMsg The message to log
  ----------------------------------------------------------------------------}
class procedure TLogLog.Debug(const AMsg: string);
begin
   if ((isInit) and not (quietMode)) then
      writeln(outFile, 'DEBUG: ' + AMsg);
end;
{*----------------------------------------------------------------------------
   Send an error message.
   @param AMsg The message to log
  ----------------------------------------------------------------------------}
class procedure TLogLog.Error(const AMsg: string);
begin
   if ((isInit) and not (quietMode)) then
      writeln(outFile, 'ERROR: ' + AMsg);
end;
{*----------------------------------------------------------------------------
   Send a warn message.
   @param AMsg The message to log
  ----------------------------------------------------------------------------}
class procedure TLogLog.Warn(const AMsg: string);
begin
   if ((isInit) and not (quietMode)) then
      writeln(outFile, 'WARN: ' + AMsg);
end;
{*----------------------------------------------------------------------------
   Send an info message.
   @param AMsg The message to log
  ----------------------------------------------------------------------------}
class procedure TLogLog.Info(const AMsg: string);
begin
   if ((isInit) and not (quietMode)) then
      writeln(outFile, 'INFO: ' + AMsg);
end;
{*----------------------------------------------------------------------------
   Send a fatal message.
   @param AMsg The message to log
  ----------------------------------------------------------------------------}
class procedure TLogLog.Fatal(const AMsg: string);
begin
   if ((isInit) and not (quietMode)) then
      writeln(outFile, 'FATAL: ' + AMsg);
end;
{*----------------------------------------------------------------------------
   This method is used to turn internal logging off. It may be used later in
   a configuration setting to prevent internal logging in shipped code.
   @param AMode True if quiet and false otherwise
  ----------------------------------------------------------------------------}
class procedure TLogLog.SetQuietMode(const AMode: Boolean);
begin
   quietMode := AMode;
end;

end.

 