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
   Contains the TXMLLayout class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TXMLLayoutUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   TLayoutUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   Format logging events as XML.
  ----------------------------------------------------------------------------}
   TXMLLayout = class (TLayout)
   private
   public
      function Format(AEvent : TLoggingEvent) : String; Override;
      function GetContentType() : String; Override;
      function IgnoresException() : Boolean; Override;
   end;

implementation

uses
  SysUtils;

{*----------------------------------------------------------------------------
   Returns the log statement in an XML format.
   @param AEvent the event to format
   @return The event formatted as an XML string  
  ----------------------------------------------------------------------------}
function TXMLLayout.Format(AEvent : TLoggingEvent) : String;
var
   tmp : String;
begin
   tmp := '<log4delphi:event timestamp="'
      + IntToStr(DateTimeToFileDate(AEvent.getStartTime))
      + '" level="' + AEvent.GetLevel.toString + '">' + LINE_SEP
      + '    <log4delphi:message><![CDATA[' + AEvent.GetMessage
      + ']]></log4delphi:message>' + LINE_SEP;
   if (AEvent.GetException <> Nil) then begin
      tmp := tmp + '    <log4delphi:exception class="'
         + AEvent.GetException.ClassName + '"><![CDATA['
         + AEvent.GetException.Message + ']]></log4delphi:exception>' + LINE_SEP;
   end;
   tmp := tmp + '</log4delphi:event>' + LINE_SEP;
   format := tmp;
end;

{*----------------------------------------------------------------------------
   Returns the content type output by this layout, "text/xml".
   @return Content type
  ----------------------------------------------------------------------------}
function TXMLLayout.GetContentType() : String;
begin
   Result := 'text/xml';
end;

{*----------------------------------------------------------------------------
   If the layout handles the Exception object contained within LoggingEvent,
   then the layout should return false. Otherwise, if the layout ignores
   Exception object, then the layout should return true. This layout does not
   ignore exceptions.
   @return Whether the exception is handled or not
  ----------------------------------------------------------------------------}
function TXMLLayout.IgnoresException() : Boolean;
begin
   Result := false;
end;

end.
 