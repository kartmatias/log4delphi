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
   Contains the TErrorHandler class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TErrorHandlerUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   SysUtils;

type
{*----------------------------------------------------------------------------
   Appenders may delegate their error handling to ErrorHandlers.
  ----------------------------------------------------------------------------}
   TErrorHandler = class (TObject)
   public
      procedure Error(const AMsg : String); Overload; Virtual; Abstract;
      procedure Error(const AMsg: String; AEx : Exception); Overload;
        Virtual; Abstract;
      procedure SetAppender(const AAppenderName : String); Virtual; Abstract;
   end;

implementation

end.
 