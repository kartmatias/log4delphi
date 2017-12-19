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
   Contains the TSimpleLayout class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TSimpleLayoutUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   TLayoutUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   SimpleLayout consists of the level of the log statement, followed by
   " - " and then the log message itself
  ----------------------------------------------------------------------------}
   TSimpleLayout = class (TLayout)
   private
   public
      function Format(AEvent : TLoggingEvent) : String; Override;
   end;

implementation

{*----------------------------------------------------------------------------
   Returns the log statement in a format consisting of the level, followed by
   " - " and then the message.
   @return The event formatted as a string  
  ----------------------------------------------------------------------------}
function TSimpleLayout.Format(AEvent : TLoggingEvent) : String;
begin
   Result := AEvent.GetLevel.ToString + ' - ' + AEvent.GetMessage;
end;

end.
 