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
   Contains the TDBLogInserter class.
   @version 0.5
   @author <a href="mailto:Bartosz.Tomasik@gmail.com">Bartosz Tomasik</a>
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}

unit TDBLogInserterUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
 TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   Database abstraction - implement this abstract class with
   support for specific databases for outputting log statements.
  ----------------------------------------------------------------------------}
  TDbLogInserter = class (TObject)
    protected
      procedure Insert(AEvent : TLoggingEvent); virtual; abstract;
    public
      procedure DoInsert(AEvent : TLoggingEvent);
  end;


implementation

procedure TDbLogInserter.DoInsert(AEvent : TLoggingEvent);
begin
  Self.Insert(AEvent);
end;

end.
 