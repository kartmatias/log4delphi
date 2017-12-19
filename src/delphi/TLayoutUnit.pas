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
   Contains the TLayout class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TLayoutUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   TLoggingEventUnit;

{*-------------------------------------------------------------------------
   A line separator consisting of ASCII characters 13 and 10.
 -------------------------------------------------------------------------}
const
  LINE_SEP = #13#10;

type
{*----------------------------------------------------------------------------
   This abstract class should be extended to create specific log layout
   formats.
  ----------------------------------------------------------------------------}
   TLayout = class (TObject)
   private
   protected
   public
      function Format(AEvent : TLoggingEvent) : String; Virtual; Abstract;
      function GetContentType() : String; Virtual;
      function GetHeader() : String; Virtual;
      function GetFooter() : String; Virtual;
      function IgnoresException() : Boolean; Virtual;
   end;

implementation

{*----------------------------------------------------------------------------
   Returns the content type output by this layout. The default implementation
   returns "text/plain".
   @return Content type
  ----------------------------------------------------------------------------}
function TLayout.GetContentType() : String;
begin
   Result := 'text/plain';
end;

{*----------------------------------------------------------------------------
   Returns the header for the layout format. The default implementation
   returns the empty string ''.
   @return Header
  ----------------------------------------------------------------------------}
function TLayout.GetHeader() : String;
begin
   Result := '';
end;

{*----------------------------------------------------------------------------
   Returns the footer for the layout format. The default implementation
   returns the empty string ''.
   @return Footer
  ----------------------------------------------------------------------------}
function TLayout.GetFooter() : String;
begin
   Result := '';
end;

{*----------------------------------------------------------------------------
   If the layout handles the Exception object contained within LoggingEvent,
   then the layout should return false. Otherwise, if the layout ignores
   Exception object, then the layout should return true.
   @return Whether the exception is handled or not
  ----------------------------------------------------------------------------}
function TLayout.ignoresException() : Boolean;
begin
   IgnoresException := true;
end;

end.
 