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
   Contains the TNullAppender class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TNullAppenderUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  TAppenderUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   This appender does not do anything making it usefull for testing purposes.
  ----------------------------------------------------------------------------}
  TNullAppender = class (TAppender)
  public
    procedure Append(AEvent : TLoggingEvent); Override;
  end;

implementation

{*----------------------------------------------------------------------------
   Does absolutely nothing.
  ----------------------------------------------------------------------------}
procedure TNullAppender.Append(AEvent : TLoggingEvent);
begin

end;

end.
 