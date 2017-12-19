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
   Contains the TLoggingEvent class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TLoggingEventUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   SysUtils,
   TLevelUnit;

type
{*----------------------------------------------------------------------------
  The internal representation of logging events. When an affirmative decision
  is made to log then a LoggingEvent instance is created. This instance is
  passed around to the different log4delphi components.
  ----------------------------------------------------------------------------}  
   TLoggingEvent = class (TObject)
   private
      FLevel : TLevel;
      FMsg : String;
      FStartTime : TDateTime;
      FException : Exception;
      FLoggerName : String;
   public
      constructor Create(ALevel : TLevel; const AMsg : String;
         const ALoggerName : String); Overload;
      constructor Create(ALevel : TLevel;
         const AMsg : String; const ALoggerName : String;
         const AEx : Exception); Overload;
      destructor Destroy; Override;
      function GetLevel() : TLevel;
      function GetMessage() : String;
      function GetStartTime() : TDateTime;
      function GetException() : Exception;
      function GetLogger() : String;
   end;

implementation

{*----------------------------------------------------------------------------
   Instantiate a LoggingEvent from the supplied parameters.
   @param ALevel The level of this event
   @param AMsg The logging message
  ----------------------------------------------------------------------------}
constructor TLoggingEvent.Create(ALevel : TLevel; const AMsg : String;
  const ALoggerName : String);
begin
   inherited Create;
   Self.Create(ALevel, AMsg, ALoggerName, Nil);
end;

{*----------------------------------------------------------------------------
   Instantiate a LoggingEvent from the supplied parameters.
   @param ALevel The level of this event
   @param AMsg The logging message
   @param AEx The exception to use
  ----------------------------------------------------------------------------}
constructor TLoggingEvent.Create(ALevel : TLevel; const AMsg : String;
  const ALoggerName : String; const AEx : Exception);
begin
   inherited Create;
   Self.FLevel := ALevel;
   Self.FMsg := AMsg;
   Self.FException := AEx;
   Self.FStartTime := Now;
   Self.FLoggerName := ALoggerName;
end;

{*----------------------------------------------------------------------------
   Free this instance.
  ----------------------------------------------------------------------------}
destructor TLoggingEvent.Destroy;
begin
   inherited Destroy;
end;

{*----------------------------------------------------------------------------
    Return the level of this event.
    @return The level  
  ----------------------------------------------------------------------------}
function TLoggingEvent.GetLevel() : TLevel;
begin
   Result := Self.FLevel;
end;

{*----------------------------------------------------------------------------
   Return the message for this logging event.
   @return The message
  ----------------------------------------------------------------------------}
function TLoggingEvent.GetMessage() : String;
begin
   Result := Self.FMsg;
end;

{*----------------------------------------------------------------------------
   Returns the time when the event was created.
   @return The creation time  
  ----------------------------------------------------------------------------}
function TLoggingEvent.GetStartTime() : TDateTime;
begin
   Result := Self.FStartTime;
end;

{*----------------------------------------------------------------------------
   Returns the exception associated with this event.
   @return The associated exception
  ----------------------------------------------------------------------------}
function TLoggingEvent.GetException() : Exception;
begin
   Result := Self.FException;
end;

{*----------------------------------------------------------------------------
   Returns the name of the logger that created this event.
   @return The logger's name
  ----------------------------------------------------------------------------}
function TLoggingEvent.GetLogger() : String;
begin
  Result := Self.FLoggerName;
end;

end.
 