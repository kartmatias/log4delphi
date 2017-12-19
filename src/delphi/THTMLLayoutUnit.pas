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
unit THTMLLayoutUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   TLayoutUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   Formats logging statements into an HTML document structuring it with
   a table. The resulting HTML is 4.01 compliant and should have no
   trouble rendering in any browser.
  ----------------------------------------------------------------------------}
   THTMLLayout = class (TLayout)
   private
      FTitle : String;
   public
      constructor Create;
      procedure SetTitle(ATitle : String);
      function GetTitle() : String;
      function Format(AEvent : TLoggingEvent) : String; Override;
      function GetContentType() : String; Override;
      function GetHeader() : String; Override;
      function GetFooter() : String; Override;
      function IgnoresException() : Boolean; Override;
   end;

implementation

uses
  SysUtils, TLogLogUnit;

{*----------------------------------------------------------------------------
   Create a new instance.
  ----------------------------------------------------------------------------}
constructor THTMLLayout.Create;
begin
   inherited Create;
   Self.FTitle := 'Log4Delphi Log Messages';
   TLogLog.Debug('THTMLLayout.Create');
end;

{*----------------------------------------------------------------------------
   Set the title of the HTML document.
   @param title The title of the document  
  ----------------------------------------------------------------------------}
procedure THTMLLayout.SetTitle(ATitle : String);
begin
   Self.FTitle := ATitle;
   TLogLog.Debug('THTMLLayout.SetTitle: ' + ATitle);   
end;

{*----------------------------------------------------------------------------
   Returns the title of the HTML document.
   @return The title of the document  
  ----------------------------------------------------------------------------}
function THTMLLayout.GetTitle() : String;
begin
   Result := Self.FTitle;
end;

{*----------------------------------------------------------------------------
   Returns the log statement in HTML format.
   @return The event formatted as an HTML string
  ----------------------------------------------------------------------------}
function THTMLLayout.Format(AEvent : TLoggingEvent) : String;
var
   excptn : String;
begin
   if (AEvent.GetException <> Nil) then
      excptn := '; Exception:' + AEvent.GetException.Message
   else
      excptn := '';
   format :=
     '                <tr>' + LINE_SEP
   + '                    <td title="Timestamp">'
   + IntToStr(DateTimeToFileDate(AEvent.GetStartTime)) + '</td>' + LINE_SEP
   + '                    <td title="Level" class="' + AEvent.GetLevel.toString
   + '">' + AEvent.GetLevel.toString + '</td>' + LINE_SEP
   + '                    <td title="Message">' + AEvent.GetMessage + excptn
   + '</td>' + LINE_SEP
   + '                </tr>' + LINE_SEP
end;

{*----------------------------------------------------------------------------
   Returns the content type output by this layout, "text/html".
   @return Content type
  ----------------------------------------------------------------------------}
function THTMLLayout.GetContentType() : String;
begin
   Result := 'text/html';
end;

{*----------------------------------------------------------------------------
   Returns the HTML header for the layout format.
   @return HTML Header
  ----------------------------------------------------------------------------}
function THTMLLayout.GetHeader() : String;
begin
   // NOTE: This method disobeys formatting by exceeding the 80 character right
   // margin in an attempt to make the html that it returns easier to read and
   // understand.
    
   getHeader :=
     '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"' + LINE_SEP
   + '    "http://www.w3.org/TR/html4/strict.dtd">' + LINE_SEP
   + '<html>' + LINE_SEP
   + '    <head>' + LINE_SEP
   + '        <title>Log4Delphi Log Messages</title>' + LINE_SEP
   + '        <style type="text/css">' + LINE_SEP
   + '        <!--' + LINE_SEP
   + '            body {background: XFFFFFF; margin: 6px; font-family: arial,sans-serif; font-size: small;}' + LINE_SEP
   + '            table {font-family: arial,sans-serif; font-size: 9pt;}' + LINE_SEP
   + '            th {background: #336699; color: #FFFFFF; text-align: left;}' + LINE_SEP
   + '            td.debug {color: #339933}' + LINE_SEP
   + '            td.warn {color: #FF9229}' + LINE_SEP
   + '            td.error {color: #CC0000}' + LINE_SEP
   + '            td.fatal {color: #FF0000}' + LINE_SEP
   + '        -->' + LINE_SEP
   + '        </style>' + LINE_SEP
   + '    </head>' + LINE_SEP
   + '    <body>' + LINE_SEP
   + '        <p>Log session start time Tue Sep 13 16:19:28 SAST 2005</p>' + LINE_SEP
   + '        <table cellspacing="0" cellpadding="4" width="100%">' + LINE_SEP
   + '            <thead>' + LINE_SEP
   + '                <tr>' + LINE_SEP
   + '                    <th>Time</th>' + LINE_SEP
   + '                    <th>Level</th>' + LINE_SEP
   + '                    <th>Message</th>' + LINE_SEP
   + '                </tr>' + LINE_SEP
   + '            </thead>' + LINE_SEP
   + '            <tbody>' + LINE_SEP;
end;

{*----------------------------------------------------------------------------
   Returns the footer for the html layout format.
   @return HTML Footer
  ----------------------------------------------------------------------------}
function THTMLLayout.GetFooter() : String;
begin
   getFooter :=
     '            </tbody>' + LINE_SEP
   + '        </table>' + LINE_SEP
   + '    </body>' + LINE_SEP
   + '</html>' + LINE_SEP
end;

{*----------------------------------------------------------------------------
   If the layout handles the Exception object contained within LoggingEvent,
   then the layout should return false. Otherwise, if the layout ignores
   Exception object, then the layout should return true. This layout handles
   exceptions.
   @return Whether the exception is handled or not
  ----------------------------------------------------------------------------}
function THTMLLayout.IgnoresException() : Boolean;
begin
   Result := false;
end;

end.
