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
   Contains the TWriterAppender class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TWriterAppenderUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   Classes,
   TAppenderUnit, TLayoutUnit, TLoggingEventUnit,
   TLevelUnit, TPrintWriterUnit;

type
{*----------------------------------------------------------------------------
   TWriterAppender appends log events to a TWriter. This can be used in
   combination with streams thus allowing logging to file streams, network
   streams or other stream based resources.
  ----------------------------------------------------------------------------}
   TWriterAppender = class (TAppender)
   private
   protected
      FWriter : TPrintWriter;
      FImmediateFlush : Boolean;
      procedure WriteFooter();
      procedure WriteHeader();
   public
      constructor Create(); Overload;
      constructor Create(ALayout : TLayout; AStream : TStream); Overload;
      destructor Destroy; Override;
      procedure Close();
      procedure Append(AEvent : TLoggingEvent); Override;
      procedure SetImmediateFlush(AFlush : Boolean);
      procedure SetStream(AStream : TStream);
      function GetImmediateFlush() : Boolean;
      function RequiresLayout() : Boolean; Override;
   end;

implementation

uses
   TLogLogUnit;

{*----------------------------------------------------------------------------
   Write a footer as produced by the embedded layout's Layout.getFooter
   method.
  ----------------------------------------------------------------------------}
procedure TWriterAppender.WriteFooter();
begin
  if (not Self.FClosed) then
    Self.FWriter.Println(Self.FLayout.GetFooter);
end;

{*----------------------------------------------------------------------------
   Write a header as produced by the embedded layout's Layout.getHeader method.
  ----------------------------------------------------------------------------}
procedure TWriterAppender.WriteHeader();
begin
  if (not Self.FClosed) then
    Self.FWriter.Println(Self.FLayout.GetHeader);
end;

{*----------------------------------------------------------------------------
   Instantiate a WriterAppender.
  ----------------------------------------------------------------------------}
constructor TWriterAppender.Create();
begin
   inherited Create;
   Self.FWriter := Nil;
   Self.FImmediateFlush := true;
end;

{*----------------------------------------------------------------------------
   Instantiate a WriterAppender and set the output destination to stream.
   This class does not free the TStream paramter, it is the callers duty
   to do so. The contained writer is, however, freed by this class.
   @param ALayout The layout to use
   @param AStream The stream to use
  ----------------------------------------------------------------------------}
constructor TWriterAppender.Create(ALayout : TLayout; AStream : TStream);
begin
   inherited Create;
   TLogLog.debug('TWriterAppender.Create');
   Self.FLayout := ALayout;
   Self.FThreshold := TLevelUnit.DEBUG;
   Self.FName := ClassName;
   Self.SetStream(AStream);
   Self.FImmediateFlush := true;
   Self.WriteHeader;
end;

{*----------------------------------------------------------------------------
   Destruct this instance by freeing the contained TWriter instance.
  ----------------------------------------------------------------------------}
destructor TWriterAppender.Destroy;
begin
   if not Self.FClosed then
      Self.Close;
   Self.FWriter.Free;
   TLogLog.debug('TWriterAppender#Destroy');
   inherited Destroy;
end;

{*----------------------------------------------------------------------------
   Close this appender instance. Closed appenders cannot be reused.
  ----------------------------------------------------------------------------}
procedure TWriterAppender.Close();
begin
   if (Self.FClosed) then
      exit;
   if (self.FLayout <> Nil) then
      Self.WriteFooter;
  Self.FClosed := true;
end;

{*----------------------------------------------------------------------------
   If the writer exists and is writable then write a log statement to the
   writer.
   @param AEvent The event to log
  ----------------------------------------------------------------------------}
procedure TWriterAppender.Append(AEvent : TLoggingEvent);
begin
   if (Self.FClosed) then begin
      if (Self.FErrorHandler <> Nil) then
         Self.FErrorHandler.Error(
            'This appender is closed and cannot be written to.');
      Exit;
   end;
   Self.FWriter.Println(Self.Flayout.Format(AEvent));
   if not (Self.Flayout.IgnoresException) then
      if (AEvent.getException <> Nil) then
         Self.FWriter.Println('Exception: ' + AEvent.GetException.Message);
end;

{*----------------------------------------------------------------------------
   If the ImmediateFlush option is set to true, the appender will flush at the
   end of each write. This is the default behavior.
   @param AFlush Whether to flush or not
  ----------------------------------------------------------------------------}
procedure TWriterAppender.SetImmediateFlush(AFlush : Boolean);
begin
   Self.FImmediateFlush := AFlush;
end;

{*----------------------------------------------------------------------------
   Setup the writer to use the given stream.
   @param AStream The stream to write to
  ----------------------------------------------------------------------------}
procedure TWriterAppender.SetStream(AStream : TStream);
begin
   Self.FWriter.Free;
   Self.FWriter := TPrintWriter.Create(AStream);
end;

{*----------------------------------------------------------------------------
   Returns value of the ImmediateFlush option.
   @return True if immediate flush is set, false otherwise
  ----------------------------------------------------------------------------}
function TWriterAppender.GetImmediateFlush() : Boolean;
begin
   Result := Self.FImmediateFlush;
end;

{*----------------------------------------------------------------------------
   Determines if this appender requires a layout. This appender does require
   a layout.
   @return True since this appender requires a layout
  ----------------------------------------------------------------------------}
function TWriterAppender.RequiresLayout() : Boolean;
begin
   Result := true;
end;

end.
