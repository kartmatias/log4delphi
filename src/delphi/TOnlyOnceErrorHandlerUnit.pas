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
   Contains the TOnlyOnceErrorHandler class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TOnlyOnceErrorHandlerUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   SysUtils, TErrorHandlerUnit;

type
{*----------------------------------------------------------------------------
   The OnlyOnceErrorHandler implements log4delphi's default error handling
   policy which consists of emitting a message for the first error in an
   appender and ignoring all following errors.
  ----------------------------------------------------------------------------}
   TOnlyOnceErrorHandler = class (TErrorHandler)
   private
      FFirstTime : Boolean;
   public
      constructor Create;
      procedure Error(const AMsg : String); Overload;  Override;
      procedure Error(const AMsg: String; AEx : Exception); Overload; Override;
      procedure SetAppender(const AAppenderName : String); Override;
   end;

implementation

uses TLogLogUnit;

{*----------------------------------------------------------------------------
   Create an instance.
  ----------------------------------------------------------------------------}
constructor TOnlyOnceErrorHandler.Create;
begin
   inherited Create;
   FFirstTime := true;
end;

{*----------------------------------------------------------------------------
   Print the error message passed as parameter.
   @param AMsg The message to print
  ----------------------------------------------------------------------------}
procedure TOnlyOnceErrorHandler.Error(const AMsg : String);
begin
   Self.Error(AMsg, Nil);
end;

{*----------------------------------------------------------------------------
   Prints the message and the message of the exception.
   @param AMsg The message to print
   @param AEx The exception to print
  ----------------------------------------------------------------------------}
procedure TOnlyOnceErrorHandler.Error(
   const AMsg: String; AEx : Exception);
begin
   if (Self.FFirstTime) then begin
      if (AEx = Nil) then
         TLogLog.Error(AMsg)
      else
         TLogLog.Error(AMsg + ' : ' + AEx.Message);
      Self.FFirstTime := false;
   end;
end;

{*----------------------------------------------------------------------------
   Does absolutely nothing.
  ----------------------------------------------------------------------------}
procedure TOnlyOnceErrorHandler.SetAppender(const AAppenderName : String);
begin
   
end;

end.
 