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
   Contains the TFileAppender class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TFileAppenderUnit;
{$IFDEF fpc}
{$MODE objfpc}
{$H+}
{$ENDIF}
interface
uses
   Classes,
   TWriterAppenderUnit, TLayoutUnit;
type
   {*----------------------------------------------------------------------------
      FileAppender appends log events to a file.
     ----------------------------------------------------------------------------}
   TFileAppender = class(TWriterAppender)
   protected
      FFileStream: TFileStream;
      FAppend: Boolean;
      FFileName: string;
   public
      constructor Create(); overload;
      constructor Create(const AFileName: string); overload;
      constructor Create(const AFileName: string; ALayout: TLayout); overload;
      constructor Create(const AFileName: string; ALayout: TLayout;
         AAppend: Boolean); overload;
      destructor Destroy; override;
      procedure setAppend(const AAppend: Boolean);
      procedure SetFile(const AFileName: string);
      procedure setLayout(ALayout: TLayout); override;
   end;
implementation
uses
   SysUtils,
   TLevelUnit, TSimpleLayoutUnit, TLogLogUnit;
{*----------------------------------------------------------------------------
   Instantiate a new FileAppender instance.
  ----------------------------------------------------------------------------}
constructor TFileAppender.Create();
begin
   inherited create;
   Self.FClosed := true;
   TLogLog.debug('TFileAppender#Create');
end;
{*----------------------------------------------------------------------------
   Instantiate a FileAppender and open the file designated by filename.
   @param AFileName The name of the file to log to
  ----------------------------------------------------------------------------}
constructor TFileAppender.Create(const AFileName: string);
begin
   self.Create(AFileName, TSimpleLayout.Create, false);
end;
{*----------------------------------------------------------------------------
   Instantiate a FileAppender and open the file designated by filename.
   @param AFileName The name of the file to log to
   @param ALayout The layout to use
  ----------------------------------------------------------------------------}
constructor TFileAppender.Create(const AFileName: string; ALayout: TLayout);
begin
   self.Create(AFileName, ALayout, false);
end;
{*----------------------------------------------------------------------------
   Instantiate a FileAppender and open the file designated by filename.
   @param AFileName The name of the file to log to
   @param ALayout The layout to use
   @param AAppend Open the file in append mode
  ----------------------------------------------------------------------------}
constructor TFileAppender.Create(const AFileName: string; ALayout: TLayout;
   AAppend: Boolean);
begin
   inherited Create;
   FAppend := AAppend;
   Self.FThreshold := TLevelUnit.DEBUG;
   Self.FImmediateFlush := true;
   Self.Flayout := ALayout;
   Self.SetFile(AFileName);
   Self.WriteHeader;
   TLogLog.debug('TAppender#Create');
end;
{*----------------------------------------------------------------------------
   Close the file and destroy the instance.
  ----------------------------------------------------------------------------}
destructor TFileAppender.Destroy;
begin
   Self.Close();
   Self.FFileStream.Free;
   TLogLog.Debug('TFileAppender#Destroy');
   inherited Destroy;
end;
{*----------------------------------------------------------------------------
   Close the current file and open the new file given.
   @param AFileName The name of the new file to use
  ----------------------------------------------------------------------------}
procedure TFileAppender.SetFile(const AFileName: string);
var
   f: TextFile;
begin
   Self.FFileName := AFileName;
   if (Self.FFileStream <> nil) then
      Self.FFileStream.Free;
   if (not DirectoryExists(ExtractFileDir(AFileName))) then
      // See https://sourceforge.net/mailarchive/message.php?msg_name=9910467652.20060117175506%40users.sourceforge.net
      ForceDirectories(IncludeTrailingPathDelimiter(ExtractFileDir(AFileName)));
   if ((FileExists(AFileName) and FAppend)) then begin
      // See https://sourceforge.net/tracker/?func=detail&aid=1798998&group_id=145326&atid=761570
      FFileStream := TFileStream.Create(AFileName, fmOpenReadWrite or fmShareDenyWrite);
{$IFDEF UNICODE}
      FFileStream.Write(TEncoding.UTF8.GetPreamble[0], High(TEncoding.UTF8.GetPreamble));
{$ENDIF}
      FFileStream.Position := FFileStream.Size;
   end else begin
      AssignFile(f, AFileName);
      ReWrite(f);
      CloseFile(f);
      FFileStream := TFileStream.Create(AFileName, fmOpenWrite or fmShareDenyWrite);
   end;

   Self.SetStream(FFileStream);
   Self.FClosed := false;
   TLogLog.Debug('TFileAppender#SetFile: ' + AFileName);
end;

{*----------------------------------------------------------------------------
   Set the Layout for this appender to use.
   @param ALayout The layout this appender uses
  ----------------------------------------------------------------------------}
procedure TFileAppender.SetLayout(ALayout: TLayout);
begin
   inherited SetLayout(ALayout);
   Self.WriteHeader;
end;
{*----------------------------------------------------------------------------
   Set whether this appender will append to the file or rewrite the contents.
   @param AAppend True for appending, false for rewriting
  ----------------------------------------------------------------------------}
procedure TFileAppender.setAppend(const AAppend: Boolean);
begin
   Self.FAppend := AAppend;
end;
end.


