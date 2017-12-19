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
   Contains the TPatternLayout class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TPatternLayoutUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  TLayoutUnit, TLoggingEventUnit;

type
{*----------------------------------------------------------------------------
   The goal of this class is to format a LoggingEvent and return the results
   as a String. The results depend on the conversion pattern. See the
   Log4Delphi User Guide for more information on using this class.  
  ----------------------------------------------------------------------------} 
  TPatternLayout = class (TLayout)
  private
    FFormatString : String;
    FDateFormatString : String;
  public
    constructor Create(); Overload;
    constructor Create(const APattern : String); Overload;
    function Format(AEvent : TLoggingEvent) : String; Override;
    function IgnoresException() : Boolean; Override;
  end;

implementation

uses
  SysUtils, TStringUnit, TLogLogUnit;

{*----------------------------------------------------------------------------
   Find the first alpha character (a..z,A..Z) in the given string from the
   specified offset.
   @param str The string to search
   @param index The offset to search from
  ----------------------------------------------------------------------------}
function FirstAlphaCharacter(str : String; index : Integer) : Integer;
var
  i : Integer;
  var tmp : STring;
begin
  tmp := Copy(Str, Index+1, (System.Length(str) - Index + 1));
  for i := 1 to Length(tmp) do
    if (tmp[i] in ['a'..'z','A'..'Z']) then begin
      Result := i + index;
      exit;
    end;
  Result := -1;
end;

{*----------------------------------------------------------------------------
   Instantiate a Pattern Layout using the default pattern: "%m%n".
  ----------------------------------------------------------------------------}
constructor TPatternLayout.Create();
begin
  Self.Create('%m%n');
end;

{*----------------------------------------------------------------------------
   Instantiate a Pattern Layout using the given pattern string.
   @param APattern The pattern to use
  ----------------------------------------------------------------------------}
constructor TPatternLayout.Create(const APattern : String);
var
  index : Integer;
  charIndex : Integer;
  pIndex : Integer;
  oldtok, newtok : String;
begin
  inherited Create;
  if (APattern <> '') then
    FFormatString := APattern
  else
    FFormatString := '%m%n';

  // loop through all conversion specifiers
  index := TStringUnit.IndexOf(FFormatString, '%', 0);
  while (index >= 0) do begin
     // find end of specifier
     charIndex := FirstAlphaCharacter(FFormatString, index);
     case FFormatString[charIndex] of
        'n' : begin
           FFormatString :=
             StringReplace(FFormatString,'%n',#13, [rfReplaceAll]);
        end;
        'm' : begin
           oldtok := Copy(FFormatString, index+1, charindex-index+1);
           newtok := StringReplace(oldtok,'m','s',[rfReplaceAll]);
           insert('0:',newtok,2);
           FFormatString :=
             StringReplace(FFormatString, oldtok, newtok, [rfReplaceAll]);
        end;
        'p' : begin
           oldtok := Copy(FFormatString, index+1, charindex-index+1);
           newtok := StringReplace(oldtok,'p','s',[rfReplaceAll]);
           insert('1:',newtok,2);
           FFormatString :=
             StringReplace(FFormatString, oldtok, newtok, [rfReplaceAll]);
        end;
        'e' : begin
           oldtok := Copy(FFormatString, index+1, charindex-index+1);
           newtok := StringReplace(oldtok,'e','s',[rfReplaceAll]);
           insert('2:',newtok,2);
           FFormatString :=
             StringReplace(FFormatString, oldtok, newtok, [rfReplaceAll]);
        end;
        'L' : begin
           oldtok := Copy(FFormatString, index+1, charindex-index+1);
           newtok := StringReplace(oldtok,'L','s',[rfReplaceAll]);
           insert('3:',newtok,2);
           FFormatString :=
             StringReplace(FFormatString, oldtok, newtok, [rfReplaceAll]);
        end;
        'd' : begin
           FDateFormatString := '';
           if (FFormatString[charIndex+1] = '{') then begin
             pIndex := IndexOf(FFormatString,'}',charIndex+1);
             if (pIndex >= 0) then begin
                FDateFormatString :=
                  Copy(FFormatString,charIndex+2,pIndex-charIndex-1);
                FFormatString := StringReplace(FFormatString, '%d{'
                  + FDateFormatString+'}', '%d', [rfReplaceAll]);
             end;
           end;
        end;
     end;
     index := IndexOf(FFormatString, '%', index+1);
  end;
  TLogLog.debug('TPatternLayout#Create');
end;

{*----------------------------------------------------------------------------
   Returns the log statement formatted using the pattern string.
   @param AEvent The event to format
   @return The event formatted using the pattern
  ----------------------------------------------------------------------------}
function TPatternLayout.Format(AEvent : TLoggingEvent) : String;
var
  ex : String;
begin
  if (AEvent.GetException <> Nil) then
    ex := AEVEnt.GetException.ClassName + ': ' + AEvent.GetException.Message
  else
    ex := '';
  Result := StringReplace(FFormatString, '%d',
    FormatDateTime(FDateFormatString, AEvent.GetStartTime), [rfReplaceAll]);
  Result := SysUtils.Format(Result, [AEvent.GetMessage,
    AEvent.GetLevel.ToString, ex, AEvent.GetLogger]);
end;

{*----------------------------------------------------------------------------
   Determines if this layout ignores exceptions. This layout does not
   ignore exceptions.
   @return False
  ----------------------------------------------------------------------------}
function TPatternLayout.IgnoresException() : Boolean;
begin
  Result := false;
end;

end.
