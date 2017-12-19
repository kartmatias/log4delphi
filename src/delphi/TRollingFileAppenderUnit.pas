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
   Contains the TRollingFileAppender class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TRollingFileAppenderUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   Classes,
   TFileAppenderUnit, TLayoutUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   RollingFileAppender appends log events to a file, occasionally rotating
   the log file.
  ----------------------------------------------------------------------------}
   TRollingFileAppender = class (TFileAppender)
   private
   protected
     FMaxBackupIndex : Integer;
     FMaxFileSize : Int64;
   public
      constructor Create(); Overload;
      constructor Create(const AFileName : String; ALayout : TLayout;
        AAppend : Boolean; AMaxBackupIndex : Integer; AMaxFileSize : Integer);
        Overload;

     procedure SetMaxBackupIndex(AIndex : Integer); Virtual;
     procedure SetMaxFileSize(ASize : Int64); Overload; Virtual; 
     procedure SetMaxFileSize(ASize : String); Overload; Virtual;
     procedure Append(AEvent : TLoggingEvent); Override;
     procedure RollOver(); Virtual;
     function GetMaxBackupIndex() : Integer; Virtual;
     function GetMaxFileSize() : Int64; Virtual;
   end;

implementation

uses
  SysUtils, TLogLogUnit;

const ONE_KB = 1024;
const ONE_MB = 1024 * ONE_KB;
const ONE_GB = 1024 * ONE_MB;

constructor TRollingFileAppender.Create();
begin
  inherited Create;
  Self.FMaxBackupIndex := 1;
  Self.FMaxFileSize := 10*1024*1024;
end;

constructor TRollingFileAppender.Create(const AFileName : String; ALayout : TLayout;
        AAppend : Boolean; AMaxBackupIndex : Integer; AMaxFileSize : Integer);
begin
  inherited Create(AFileName, ALayout, AAppend);
  Self.FMaxBackupIndex := AMaxBackupIndex;
  Self.FMaxFileSize := AMaxFileSize;
end;                


procedure TRollingFileAppender.SetMaxBackupIndex(AIndex : Integer);
begin
  Self.FMaxBackupIndex := AIndex;
end;

procedure TRollingFileAppender.SetMaxFileSize(ASize : Int64);
begin
  Self.FMaxFileSize := ASize;
end;

procedure TRollingFileAppender.SetMaxFileSize(ASize : String);
begin
  if (ASize[Length(ASize)] = 'K') then begin
    Self.FMaxFileSize := StrToInt(Copy(ASize, 0, Length(ASize)-1)) * ONE_KB;
    TLogLog.debug('Set max file size to KB');
  end;
  if (ASize[Length(ASize)] = 'M') then begin
    Self.FMaxFileSize := StrToInt(Copy(ASize, 0, Length(ASize)-1)) * ONE_MB;
    TLogLog.debug('Set max file size to MB');
  end;
  if (ASize[Length(ASize)] = 'G') then begin
    Self.FMaxFileSize := StrToInt(Copy(ASize, 0, Length(ASize)-1)) * ONE_GB;
    TLogLog.debug('Set max file size to BB');
  end;
end;

procedure TRollingFileAppender.Append(AEvent : TLoggingEvent);
begin
  inherited Append(AEvent);
  if (Self.FFileStream.Position >= Self.FMaxFileSize) then
    Self.RollOver;
  TLogLog.debug('TRollingFileAppender#Append');    
end;

procedure TRollingFileAppender.RollOver();
var
  i : Integer;
  fileName : String;
begin
  TLogLog.debug('TRollingFileAppender#RollOver: Start');
  if (Self.FMaxBackupIndex > 0) then begin
    TLogLog.debug('TRollingFileAppender#RollOver: max index > 0');
    // Delete the oldest file if it exists
    if (FileExists(FFileName + '.' + IntToStr(FMaxBackupIndex))) then begin
      DeleteFile(FFileName + '.' + IntToStr(FMaxBackupIndex));
      TLogLog.debug('TRollingFileAppender#RollOver: deleted old file');
    end;

    // Map {(maxBackupIndex - 1), ..., 2, 1} to {maxBackupIndex, ..., 3, 2}
    for i := Self.FMaxBackupIndex-1 downto 1 do begin
      fileName := Self.FFileName + '.' + IntToStr(i);
      TLogLog.debug('TRollingFileAppender#RollOver: renaming ' + fileName);
      if (FileExists(fileName)) then begin
        RenameFile(fileName, Self.FFileName + '.' + IntToStr(i + 1));
        TLogLog.debug('TRollingFileAppender#RollOver: renamed ' + fileName);
      end;
    end;

    // Rename fileName to fileName.1
    Self.FFileStream.Free;
    Self.FFileStream := Nil;
    TLogLog.debug('TRollingFileAppender#RollOver: freed the filestream');
    RenameFile(Self.FFileName, Self.FFileName + '.1');
  end;
  // reinitialize the file.
  Self.SetFile(Self.FFileName);
  TLogLog.debug('TRollingFileAppender#RollOver: End');
end;

function TRollingFileAppender.GetMaxBackupIndex() : Integer;
begin
  Result := Self.FMaxBackupIndex;
end;

function TRollingFileAppender.GetMaxFileSize() : Int64;
begin
  Result := Self.FMaxFileSize;
end;

end.
 