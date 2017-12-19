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
   Contains the TLevel class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TLevelUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   SysUtils;

{*-------------------------------------------------------------------------
   The minimum value that an integer can hold: -2147483648.
 -------------------------------------------------------------------------}
const MIN_VALUE = Low(LongInt);

{*-------------------------------------------------------------------------
   The mmaximum value that an integer can hold: 2147483647.
 -------------------------------------------------------------------------}
const MAX_VALUE = High(LongInt);

{*-------------------------------------------------------------------------
   Integer value for OFF: MAX_VALUE
 -------------------------------------------------------------------------}
const OFF_INT = MAX_VALUE;

{*-------------------------------------------------------------------------
   Integer value for FATAL: 50000
 -------------------------------------------------------------------------}
const FATAL_INT = 60000;

{*-------------------------------------------------------------------------
   Integer value for ERROR: 40000
 -------------------------------------------------------------------------}
const ERROR_INT = 50000;

{*-------------------------------------------------------------------------
   Integer value for WARN: 30000
 -------------------------------------------------------------------------}
const WARN_INT  = 40000;

{*-------------------------------------------------------------------------
   Integer value for INFO: 20000
 -------------------------------------------------------------------------}
const INFO_INT  = 30000;

{*-------------------------------------------------------------------------
   Integer value for DEBUG: 10000
 -------------------------------------------------------------------------}
const DEBUG_INT = 20000;

{*-------------------------------------------------------------------------
   Integer value for DEBUG: 10000
 -------------------------------------------------------------------------}
const TRACE_INT = 10000;

{*-------------------------------------------------------------------------
   Integer value for ALL: MIN_VALUE 
 -------------------------------------------------------------------------}
const ALL_INT = MIN_VALUE;

type
{*----------------------------------------------------------------------------
  Defines the minimum set of levels recognized by the system, that is
  <code>OFF</code>, <code>FATAL</code>, <code>ERROR</code>, <code>WARN</code>,
  <code>INFO</code>, <code>DEBUG</code> and <code>ALL</code>.
  The <code>Level</code> class may be subclassed to define a larger level set.
  ----------------------------------------------------------------------------}
   TLevel = class (TObject)
   private
      FLevelValue : Integer;
      FName : String;
      constructor Create(const ALevel : Integer; const AName : String);
   protected
   public
      function Equals(ALevel : TLevel) : Boolean;
      function IsGreaterOrEqual(ALevel : TLevel) : Boolean;
      function ToString() : String;
      function IntValue() : Integer;
   end;

  function toLevel(AString : String) : TLevel; 

var
   {*-------------------------------------------------------------------------
      OFF has the highest possible rank and is intended to turn off logging.
     -------------------------------------------------------------------------}
   OFF : TLevel;

   {*-------------------------------------------------------------------------
      FATAL designates very severe error events that will presumably lead
      the application to abort.
     -------------------------------------------------------------------------}      
   FATAL : TLevel;

   {*-------------------------------------------------------------------------
      ERROR designates error events that usually still allow the application
      to continue running normally.
     -------------------------------------------------------------------------}
   ERROR : TLevel;

   {*-------------------------------------------------------------------------
      WARN designates potentially harmful situations.
     -------------------------------------------------------------------------}   
   WARN : TLevel;

   {*-------------------------------------------------------------------------
      INFO designates informational messages that highlight the progress of
      the application at coarse-grained level.
     -------------------------------------------------------------------------}   
   INFO : TLevel;

   {*-------------------------------------------------------------------------
      DEBUG designates fine-grained informational events that are most useful
      to debug an application.
     -------------------------------------------------------------------------}   
   DEBUG : TLevel;

   {*-------------------------------------------------------------------------
      TRACE designates fine-grained informational events that are most useful
      to debug an application.
     -------------------------------------------------------------------------}   
   TRACE : TLevel;   

   {*-------------------------------------------------------------------------
      ALL has the lowest possible rank and is intended to turn on all logging.
     -------------------------------------------------------------------------}
   ALL : TLevel;

implementation

{*----------------------------------------------------------------------------
   Returns the level instance whose name matches the given string.
   @param AString The name of the level to look for
   @return The level matching the given name, Nil if not found
  ----------------------------------------------------------------------------}
function ToLevel(AString : String) : TLevel;
begin
   Result := Nil;
   if (CompareText(AString, 'OFF') = 0) then result := OFF;
   if (CompareText(AString, 'FATAL') = 0) then result := FATAL;
   if (CompareText(AString, 'ERROR') = 0) then result := ERROR;
   if (CompareText(AString, 'WARN') = 0) then result := WARN;
   if (CompareText(AString, 'INFO') = 0) then result := INFO;
   if (CompareText(AString, 'DEBUG') = 0) then result := DEBUG;
   if (CompareText(AString, 'TRACE') = 0) then result := TRACE;
   if (CompareText(AString, 'ALL') = 0) then result := ALL;
end;

{*----------------------------------------------------------------------------
   Instantiate a Level object.
   @param ALevel The integer value of the level
   @param AName The name of the level  
  ----------------------------------------------------------------------------}
constructor TLevel.Create(const ALevel : Integer; const AName : String);
begin
   inherited Create;
   Self.FLevelValue := ALevel;
   Self.FName := AName;
end;

{*----------------------------------------------------------------------------
   Two levels are equal if their integer values are equal.
   @param ALevel The level to compare with
   @return True if the given level is equal to this one, false otherwise
  ----------------------------------------------------------------------------}
function TLevel.Equals(ALevel : TLevel) : Boolean;
begin
   Result := (Self.FLevelValue = ALevel.FLevelValue);
end;

{*----------------------------------------------------------------------------
   Returns true if this level has a higher or equal integer value than the
   level passed as argument, false otherwise.
   @param ALevel The level to compare with
   @return True if given level is greater than or equal to this one, false
     otherwise
  ----------------------------------------------------------------------------}
function TLevel.IsGreaterOrEqual(ALevel : TLevel) : Boolean;
begin
   if (ALevel = Nil) then
      raise Exception.Create('Level is Nil');
   Result := (Self.FLevelValue >= ALevel.FLevelValue);
end;

{*----------------------------------------------------------------------------
   Returns the string representation of this level.
   @return String representation  
  ----------------------------------------------------------------------------}
function TLevel.ToString() : String;
begin
   Result := Self.FName;
end;

{*----------------------------------------------------------------------------
   Returns the integer representation of this level.
   @return Integer representation  
  ----------------------------------------------------------------------------}
function TLevel.IntValue() : Integer;
begin
   Result := Self.FLevelValue;
end;

{*----------------------------------------------------------------------------
   Initialize the default level set.
  ----------------------------------------------------------------------------}
initialization
begin
   OFF := TLevel.Create(OFF_INT, 'OFF');
   FATAL := TLevel.Create(FATAL_INT, 'FATAL');
   ERROR := TLevel.Create(ERROR_INT, 'ERROR');
   WARN := TLevel.Create(WARN_INT, 'WARN');
   INFO := TLevel.Create(INFO_INT, 'INFO');
   DEBUG := TLevel.Create(DEBUG_INT, 'DEBUG');
   TRACE := TLevel.Create(TRACE_INT, 'TRACE');
   ALL := TLevel.Create(ALL_INT, 'ALL');
end;

{*----------------------------------------------------------------------------
   Free the default level set.
  ----------------------------------------------------------------------------}
finalization
begin
   OFF.Free;
   FATAL.Free;
   ERROR.Free;
   WARN.Free;
   INFO.Free;
   DEBUG.Free;
   TRACE.Free;
   ALL.Free;
end;

end.


