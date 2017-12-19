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
   Contains the TOptionConverter class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TOptionConverterUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  TPropertiesUnit;

const
   DELIM_START = '${';
   DELIM_STOP = '}';
   DELIM_START_LEN = 2;
   DELIM_STOP_LEN = 1;

type
   TOptionConverter = class (TObject)
   private
   protected
   public
      class function FindAndSubst(const AKey : String; AProps : TProperties) : String;
      class function SubstVars(const AValue : String; AProps : TProperties) : String;
      class function IndexOf(const S : String; subStr : String; index : Integer) : Integer;
      class function SubString(const S: String; startIndex : Integer; endIndex : Integer) : String;
   end;


implementation

uses
  SysUtils;

class function TOptionConverter.IndexOf(const S : String; subStr : String; index : Integer) : Integer;
var
   tmp : String;
begin
   tmp := Copy(subStr, Index, System.Length(subStr) - Index);
   result := Pos(subStr, S);
   if (result > 0) then
      result := result + Index
   else
      result := -1;
end;

class function TOptionConverter.SubString(const S: String; startIndex : Integer; endIndex : Integer) : String;
begin
   substring := Copy(S, StartIndex, (StartIndex + EndIndex));
end;

class function TOptionConverter.FindAndSubst(const AKey : String; AProps : TProperties) : String;
var
   value : STring;
begin
   value := AProps.GetProperty(AKey);
   try
      result := SubstVars(value, AProps);
   except
      on Exception do
         result := value;
   end;
end;

class function TOptionConverter.SubstVars(const AValue : String; AProps : TProperties) : String;
var
   buf, key, replacement : String;
   i,j,k : Integer;
begin
   buf := '';
   i := 0;

   while (true) do begin
      j := indexOf(AValue, DELIM_START, i);
      if (j = -1) then begin // No DELIM found
         if (i = 0) then begin
             result := AValue;
             exit;
         end else begin
            buf := buf + Substring(AValue, i, System.Length(AValue));
            result := buf;
            exit;
         end;
      end else begin // DELIM found
         buf := buf + SubString(AVAlue, i, j);
         k := IndexOf(AVAlue, DELIM_STOP, j);
         if (k = -1) then begin
            raise Exception.Create('"' + AVAlue + '" has no closing brace.'
               + ' Opening brace at ' + IntToStr(j) + '.');
         end else begin
            j := j + DELIM_START_LEN;
            key := SubString(AVAlue, j, k);
            replacement := AProps.GetProperty(key);
            if (replacement <> '') then
               buf := buf + replacement;
            i := k + DELIM_STOP_LEN;
         end;
      end;
   end;
end;

end.
