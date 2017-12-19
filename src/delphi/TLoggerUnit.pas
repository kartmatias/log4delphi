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
   Contains the TLogger class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TLoggerUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  SysUtils, Classes,
  TLogLogUnit, TLevelUnit, TAppenderUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   This is the central class in the log4delphi suite. Most logging operations,
   except configuration, are done through this class.
  ----------------------------------------------------------------------------}
   TLogger = class (TObject)
   private
      FAppenders : TAppendersCollection;
      FLevel : TLevel;
      FName : String;
   protected
      constructor Create(const AName : String);
      destructor Destroy; Reintroduce;
   public
      class procedure FreeInstances();
      class function GetInstance() : TLogger; Overload;
      class function GetInstance(const AName : String) : TLogger; Overload;

      procedure SetLevel(ALevel : TLevel);
      procedure AddAppender(AAppender : IAppender);
      procedure RemoveAppender(const AName : String);
      procedure RemoveAllAppenders();
      function GetAppender(const AName : String) : IAppender;
      function GetAllAppenders() : TAppendersCollection;
      function GetLevel() : TLevel;
      function GetName() : String;

      procedure Log(AEvent : TLoggingEvent); Overload;
      procedure Log(ALevel : TLevel; const AMsg : String); Overload;
      procedure Log(ALevel : TLevel; const AMsg : String; AException
        : exception); Overload;
      procedure Fatal(const AMsg : String);
      procedure Error(const AMsg : String);
      procedure Warn(const AMsg : String);
      procedure Info(const AMsg : String);
      procedure Debug(const AMsg : String);
      procedure Trace(const AMsg : String);
   end;

procedure initialize();
procedure setDefaultThreshold(ALevel : TLevel);

implementation

var
   instances : TStrings;
   defaultThreshold : TLevel;

{*----------------------------------------------------------------------------
   Initailize the loggers.
  ----------------------------------------------------------------------------}
procedure initialize();
begin
   defaultThreshold := TLevelUnit.ALL;
   if not assigned(instances) then
      instances := TStringList.Create;
   if instances.IndexOf('ROOT') = -1  then
      instances.AddObject('ROOT', TLogger.Create('ROOT'));
end;

{*----------------------------------------------------------------------------
   Set the default threshold to all.
  ----------------------------------------------------------------------------}
procedure SetDefaultThreshold(ALevel : TLevel);
begin
   if (ALevel <> Nil) then
      defaultThreshold := ALevel;
end;

{*----------------------------------------------------------------------------
   Protected constuctor to prevent instantiation. The singleton instance
   should be accessed using the getInstance method.
  ----------------------------------------------------------------------------}
constructor TLogger.Create(const AName: String);
begin
   inherited Create;
   FAppenders := TAppendersCollection.Create;
   FLevel := defaultThreshold;
   FName := AName;
   TLogLog.debug('Logger created - name=' + FName + ', level=' + FLevel.toString);
end;

{*----------------------------------------------------------------------------
   Protected destructor to prevent destruction. The singleton instance should
   be destroyed upon application termination using the freeInstance method.
  ----------------------------------------------------------------------------}
destructor TLogger.Destroy;
begin
   FAppenders.Clear;
   FAppenders.Free;
   TLogLog.debug('Logger destroyed - name=' + FName);
   Inherited Destroy;
end;

{*----------------------------------------------------------------------------
   Destroy the all instances.
  ----------------------------------------------------------------------------}
class procedure TLogger.FreeInstances();
var
   i : Integer;
begin
   for i := 0 to instances.Count-1 do
      if instances.Objects[i] <> nil then
         TLogger(instances.Objects[i]).Destroy;
   instances.Free;
   instances := nil;
   TLogLogUnit.finalize;
end;

{*----------------------------------------------------------------------------
   Retrun a reference to the ROOT logger.
   @return Root Logger instance
  ----------------------------------------------------------------------------}
class function TLogger.GetInstance() : TLogger;
begin
   Result := TLogger(instances.Objects[0]);
end;

{*----------------------------------------------------------------------------
   Retrun a reference to the named logger.
   @param AName The name of the logger
   @return Named Logger instance
  ----------------------------------------------------------------------------}
class function TLogger.GetInstance(const AName : String) : TLogger;
var
   index : Integer;
   logger : TLogger;
begin
   index := Instances.IndexOf(AName);
   if (index < 0) then begin
      logger := TLogger.Create(AName);
      instances.AddObject(AName, logger);
      Result := logger;
   end else
   Result := TLogger(instances.Objects[index]);
end;

{*----------------------------------------------------------------------------
   Set the level of this Logger.
   @param ALevel The level to set
  ----------------------------------------------------------------------------}
procedure TLogger.SetLevel(ALevel : TLevel);
begin
   Self.FLevel := ALevel;
   TLogLog.Debug('TLogger.SetLevel: ' + ALevel.ToString);
end;

{*----------------------------------------------------------------------------
   Add an appender to the list of appenders of this Logger.
   @param AAppender The appender to add
  ----------------------------------------------------------------------------}
procedure TLogger.AddAppender(AAppender : IAppender);
begin
   FAppenders.Add(AAppender);
   TLogLog.debug('Appender added to ' + FName + ', named ' + AAppender.getName);
end;

{*----------------------------------------------------------------------------
   Remove the appender from the list of appenders.
   @param AName The name of the appender to remove
  ----------------------------------------------------------------------------}
procedure TLogger.RemoveAppender(const AName : String);
begin
   FAppenders.Delete(AName);
   TLogLog.debug('Appender removed from ' + FName + ', named ' + AName);
end;

{*----------------------------------------------------------------------------
   Remove all the appenders from this logger.
  ----------------------------------------------------------------------------}
procedure TLogger.RemoveAllAppenders();
begin
   FAppenders.Clear;
   TLogLog.Debug('TLogger.RemoveAllAppenders');
end;

{*----------------------------------------------------------------------------
   Return the appender with that name if in the list. Return Nil otherwise.
   @param AName The name of the appender
   @return The appender or Nil if not found
  ----------------------------------------------------------------------------}
function TLogger.GetAppender(const AName : String) : IAppender;
begin
   Result := FAppenders.FindByName(AName);
end;

{*----------------------------------------------------------------------------
   Get the appenders contained in this Logger as a TStrings instance. The
   caller should not destroy the TStrings instance.
   @return All appenders in a TStrings instance
  ----------------------------------------------------------------------------}
function TLogger.GetAllAppenders() : TAppendersCollection;
begin
   getAllAppenders := self.FAppenders;
end;

{*----------------------------------------------------------------------------
   Returns the assigned Level, if any, for this Logger.
   @return The level of this Logger
  ----------------------------------------------------------------------------}
function TLogger.GetLevel() : TLevel;
begin
   Result := Self.FLevel;
end;

{*----------------------------------------------------------------------------
   Return the logger name.
   @return Logger name
  ----------------------------------------------------------------------------}
function TLogger.GetName() : String;
begin
   Result := Self.FName;
end;

{*----------------------------------------------------------------------------
   Send the event to all appender on condition that the event's level is
   greater or equal to this Logger's level.
   @param AEvent The logging event to log
  ----------------------------------------------------------------------------}
procedure TLogger.Log(AEvent : TLoggingEvent);
var
   i : Integer;
begin
   if (AEvent.getLevel.isGreaterOrEqual(Self.FLevel)) then
      for i := 0 to FAppenders.Count-1 do
         FAppenders[i].doAppend(AEvent);
end;

{*----------------------------------------------------------------------------
   A generic form used to log a message. A new LoggingEvent is created and
   then destroyed upon logging the event.
   @param ALevel The level of the message to log
   @param AMsg The message to log
  ----------------------------------------------------------------------------}
procedure TLogger.Log(ALevel : TLevel; const AMsg : String);
var
   event : TLoggingEvent;
begin
   event := TLoggingEvent.Create(ALevel, AMsg, FName);
   log(event);
   event.Destroy;
end;

{*----------------------------------------------------------------------------
   A generic form used to log a message. A new LoggingEvent is created and
   then destroyed upon logging the event.
   @param ALevel The level of the message to log
   @param AMsg The message to log
   @param AException The Exception
  ----------------------------------------------------------------------------}
procedure TLogger.Log(ALevel : TLevel; const AMsg : String; AException
  : exception);
var
   event : TLoggingEvent;
begin
   event := TLoggingEvent.Create(ALevel, AMsg, FName, AException);
   log(event);
   event.Destroy;
end;

{*----------------------------------------------------------------------------
   A generic form used to log a fatal message.
  ----------------------------------------------------------------------------}
procedure TLogger.Fatal(const AMsg : String);
begin
   log(TLevelUnit.FATAL, AMsg);
end;

{*----------------------------------------------------------------------------
   A generic form used to log an error message.
  ----------------------------------------------------------------------------}
procedure TLogger.Error(const AMsg : String);
begin
   log(TLevelUnit.ERROR, AMsg);
end;

{*----------------------------------------------------------------------------
   A generic form used to log a warn message.
  ----------------------------------------------------------------------------}
procedure TLogger.Warn(const AMsg : String);
begin
   log(TLevelUnit.WARN, AMsg);
end;

{*----------------------------------------------------------------------------
   A generic form used to log an info message.
  ----------------------------------------------------------------------------}
procedure TLogger.Info(const AMsg : String);
begin
   log(TLevelUnit.INFO, AMsg);
end;

{*----------------------------------------------------------------------------
   A generic form used to log a debug message.
  ----------------------------------------------------------------------------}
procedure TLogger.Debug(const AMsg : String);
begin
   log(TLevelUnit.DEBUG, AMsg);
end;

{*----------------------------------------------------------------------------
   A generic form used to log a trace message.
  ----------------------------------------------------------------------------}
procedure TLogger.Trace(const AMsg : String);
begin
   log(TLevelUnit.TRACE, AMsg);
end;

end.
