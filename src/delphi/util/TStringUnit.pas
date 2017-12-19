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
   Contains the TString class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TStringUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   SysUtils, Classes;

type
{*----------------------------------------------------------------------------
   This class is meant to mimic the java.lang.String class and is provided
   purely for utility in that it extends TObject it may be used as an
   object in a TStrings list.
  ----------------------------------------------------------------------------}
TString = class (TObject)
   private
      FValue : String;
      FCount : Integer;
      FOffset : Integer;
   public
      constructor Create; Overload;
      constructor Create(const AValue : array of char); Overload;
      constructor Create(const AValue : String); Overload;
      constructor Create(const AValue : TString); Overload;

      procedure SetString(const AString : String);
      procedure ToUppercase();
      procedure ToLowerCase();
      procedure Trim();

      function CharAt(const AIndex : Integer) : Char;
      function CompareTo(const AString : String) : Integer;
      function CompareToIgnoreCase(const AString : String) : Integer;
      function Concat(const str : String) : TString;
      function EndsWith(const ASuffix : String) : Boolean; Overload;
      function EndsWith(const ASuffix : String; AOffset : Integer) :
         Boolean; Overload;
      function Equals(const AString : String) : Boolean;
      function EqualsIgnoreCase(const AString : String) : Boolean;
      function IndexOf(const AChar : Char) : Integer; Overload;
      function IndexOf(const ACHar : Char; const AIndex : Integer) :
         Integer; Overload;
      function IndexOf(const Astring : String) : Integer; Overload;
      function IndexOf(const AString : String; const AIndex : Integer) :
         Integer; Overload;
      function LastIndexOf(const AChar : Char) : Integer; Overload;
      function LastIndexOf(const AChar : Char; const AIndex : Integer) :
         Integer; Overload;
      function LastIndexOf(const AString : String) : Integer; Overload;
      function LastIndexOf(const AString : String; const AIndex : Integer) :
         Integer; Overload;
      function Length() : Integer;
      function Replace(const AOldChar : Char; const ANewChar : Char) : TString;
      function StartsWith(const AString : String) : Boolean; Overload;
      function StartsWith(const AString : String; const AIndex : Integer) :
         Boolean; Overload;
      function Substring(const AStartIndex : Integer) : TString; Overload;
      function Substring(const AStartIndex : Integer; const AEndIndex : Integer) :
         TString; Overload;
      function ToString() : String;
   end;

   TStringTokenizer = class (TObject)
   private
      FCurrentPosition : Integer;
      FTokens : TStringList;
   protected
   public
      constructor Create(const AStr : String); Overload;
      constructor Create(const AStr : String; ADelim : String); Overload;
      constructor Create(const AStr : String;  ADelim : String;
        returnDelims : Boolean); Overload;
      destructor Destroy; Override;
      function HasMoreTokens() : Boolean;
      function NextToken() : String;
      function CountTokens() : Integer;
   end;

function EndsWith(const S : String; const ASuffix : String; AOffset : Integer) : Boolean;
function IndexOf(const S : String; const AString : String; const AIndex : Integer) : Integer;
function LastIndexOf(const S : String; const AString : String; const AIndex : Integer) : Integer;
function StartsWith(const S : String; const AString : String; const AIndex : Integer) : Boolean;   

implementation

Function ReverseString(S : String): String;
Var
   i : Integer;
Begin
   Result := '';
   For i := Length(S) DownTo 1 Do
   Begin
     Result := Result + Copy(S,i,1) ;
   End;
End;


constructor TString.Create;
begin
   FValue := '';
   FCount := 0;
   FOffset := 1;
end;

constructor TString.Create(const AValue : array of char);
begin
   FValue := AValue;
   FCount := System.length(FValue);
   FOffset := 1;
end;

constructor TString.Create(const AValue : String);
begin
   FValue := AValue;
   FCount := System.length(FValue);
   FOffset := 1;
end;

constructor TString.Create(const AValue : TString);
begin
   FValue := AValue.FValue;
   FCount := System.length(FValue);
   FOffset := 1;
end;

procedure TString.SetString(const AString : String);
begin
   FValue := AString;
   FCount := System.length(FValue);
   FOffset := 1;
end;

procedure TString.ToUppercase();
begin
   FValue := Uppercase(FValue);
end;

procedure TString.ToLowerCase();
begin
   FValue := LowerCase(FValue);
end;

procedure TString.Trim();
begin
   FValue := SysUtils.Trim(FValue);
   FCount := System.Length(FValue);
end;

function TString.CharAt(const AIndex : Integer) : Char;
begin
   CharAt := FValue[AIndex + FOffset];
end;

function TString.CompareTo(const AString : String) : Integer;
begin
   CompareTo := CompareStr(FValue, AString);
end;

function TString.CompareToIgnoreCase(const AString : String) : Integer;
begin
   CompareToIgnoreCase := CompareText(FValue, AString);
end;

function TString.Concat(const str : String) : TString;
begin
   Concat := TString.Create(FValue + str);
end;

function TString.EndsWith(const ASuffix : String) : Boolean;
begin
   EndsWith := EndsWith(ASuffix, 0);
end;

function TString.EndsWith(const ASuffix : String; AOffset : Integer) : Boolean;
var
   tmp : String;
begin
   if (System.Length(ASuffix) > FCount) then
      result := false
   else if (AOffset > (FCount - System.Length(ASuffix)+1)) then
      result := false
   else begin
      tmp := Copy(FValue,AOffset, System.Length(ASuffix));
      result := (CompareStr(ASuffix, tmp) = 0);      
   end;
end;

function TString.Equals(const AString : String) : Boolean;
begin
   Equals := (CompareStr(FValue, AString) = 0);
end;

function TString.EqualsIgnoreCase(const AString : String) : Boolean;
begin
   EqualsIgnoreCase := (CompareText(FValue, AString) = 0);
end;

function TString.IndexOf(const AChar : Char) : Integer;
begin
   IndexOf := IndexOf(AChar, 0);
end;

function TString.IndexOf(const AChar : Char; const AIndex : Integer) : Integer;
var
   fromIndex, res, i : Integer;
begin
   fromIndex := AIndex;
   if (fromIndex < 0) then
      fromIndex := 1;
   if (fromIndex > FCount) then begin
      IndexOf := -1;
      exit;
   end;
   res := -1;
   for i := AIndex to FCount do
      if (FValue[i] = AChar) then
         res := i;
   IndexOf := res;
end;

function TString.indexOf(const AString : String) : Integer;
begin
   IndexOf := IndexOf(Astring ,0);
end;

function TString.IndexOf(const AString : String; const AIndex : Integer) : Integer;
var
   tmp : String;
begin
   tmp := Copy(AString, AIndex, System.Length(AString) - AIndex);
   result := Pos(AString, FValue);
   if (result >= 0) then
      result := result + AIndex;
end;

function TString.LastIndexOf(const AChar : Char) : Integer;
begin
   LastIndexOf := LastIndexOf(AChar, FCount);
end;

function TString.LastIndexOf(const AChar : Char; const AIndex : Integer) : Integer;
var
   fromIndex, i : Integer;
   res : Integer;
begin
   res := -1;
   fromIndex := AIndex;
   if (fromINdex > FCount) then
      fromIndex := FCount;
   for i := fromIndex downto 1 do
      if (FValue[i] = AChar) then
         res := i;
   lastIndexOf := res;
end;

function TString.LastIndexOf(const AString : String) : Integer;
begin
   LastIndexOf := LastIndexOf(AString, FCount);
end;

function TString.LastIndexOf(const AString : String; const AIndex : Integer) : Integer;
var
   tmp : String;
   res, index : Integer;
begin
   tmp := Copy(AString, AIndex, System.Length(AString) - AIndex);
   index := Pos(AString, tmp);
   res := 0;
   while (index >= 0) do begin
      res := res + index;
      tmp := Copy(tmp, index+1, System.length(tmp)-index+1);
      index := Pos(AString, tmp);
   end;
   result := res;
end;

function TString.Length() : Integer;
begin
   Length := FCount;
end;

function TString.Replace(const AOldChar : Char; const ANewChar : Char) : TString;
begin
   Replace := TString.Create(StringReplace(FValue, AOldChar, ANewChar, [rfReplaceAll]));
end;

function TString.StartsWith(const AString : String) : Boolean;
begin
   StartsWith := StartsWith(AString, 0);
end;

function TString.StartsWith(const AString : String; const AIndex : Integer) : Boolean;
var
   tmp : String;
begin
   if (System.Length(AString) > FCount) then
      result := false
   else if (AIndex > (FCount - System.Length(AString))) then
      result := false
   else begin
      tmp := Copy(FValue,AIndex+1, System.Length(AString));
      result := (CompareStr(AString, tmp) = 0);
   end;
end;

function TString.Substring(const AStartIndex : Integer) : TString;
begin
   Substring := TString.Create(Copy(FValue, AStartIndex, System.Length(FValue)));
end;

function TString.Substring(const AStartIndex : Integer; const AEndIndex : Integer) : TString;
begin
   substring := TString.Create(Copy(FValue, AStartIndex, (AStartIndex + AEndIndex)));
end;

function TString.ToString() : String;
begin
   ToString := FValue;
end;






constructor TStringTokenizer.Create(const AStr : String);
begin
  Self.Create(Astr, ' '+#9#10#13, false);
end;

constructor TStringTokenizer.Create(const AStr : String; ADelim : String);
begin
  Self.Create(Astr, ADelim, false);
end;

constructor TStringTokenizer.Create(const AStr : String;  ADelim : String;
   returnDelims : Boolean);
var
  count : Integer;
  prev : Integer;
begin
  FCurrentPosition := 0;
  FTokens := TStringList.Create;
  prev := 1;
  for count := 0 to Length(Astr) do begin
    if (IsDelimiter(ADelim, AStr, count)) then begin
      if (Copy(AStr,prev,count-prev) <> '') then
        FTokens.Add(Copy(AStr,prev,count-prev));
      prev := count;
      if (returnDelims) then
        FTokens.add(Copy(AStr,prev,1));
      prev := prev + 1;
    end;
  end;
  if (prev < Length(AStr)) then begin
    FTokens.Add(Copy(AStr,prev,Length(AStr)-prev+1));
  end;
end;

destructor TStringTokenizer.Destroy;
begin
   FTokens.Free;
end;

function TStringTokenizer.HasMoreTokens() : Boolean;
begin
  result := (FCurrentPosition < FTokens.Count);
end;

function TStringTokenizer.NextToken() : String;
begin
  result := FTokens[FCurrentPosition];
  FCurrentPosition := FCurrentPosition + 1;
end;

function TStringTokenizer.CountTokens() : Integer;
begin
  result := FTokens.Count-FCurrentPosition;
end;





function EndsWith(const S : String; const ASuffix : String; AOffset : Integer) : Boolean;
var
   tmp : String;
begin
   if (System.Length(ASuffix) > System.length(S)) then begin
      result := false
   end else if (AOffset > (System.length(S) - System.Length(ASuffix)+1)) then begin
      result := false
   end else begin
      tmp := Copy(S,AOffset, System.Length(S));
      tmp := Copy(S, (System.Length(S) - System.Length(ASuffix) + 1), System.length(ASuffix));
      result := (CompareStr(ASuffix, tmp) = 0);      
   end;
end;

function IndexOf(const S : String; const AString : String; const AIndex : Integer) : Integer;
var
  tmp : String;
begin
  tmp := Copy(S, AIndex+1, (System.Length(S) - AIndex + 1));
  result := Pos(AString, tmp);
  if (result > 0) then
    result := result + AIndex - 1
  else
    Result := -1;
end;

function LastIndexOf(const S : String; const AString : String; const AIndex : Integer) : Integer;
var
   tmp : String;
   i : Integer;
begin
  tmp := Copy(S, AIndex+1, (System.Length(S) - AIndex + 1));
  tmp := reverseString(tmp);
  i := IndexOf(tmp, AString, 0);
  i := System.Length(S) - i - 1;
  if (i < System.Length(S)) then
    Result := i
  else
    Result := -1;
end;

function StartsWith(const S : String; const AString : String; const AIndex : Integer) : Boolean;
var
   tmp : String;
begin
   if (System.Length(AString) > System.length(S)) then begin
      result := false
   end else if (AIndex > (System.length(S) - System.Length(AString))) then begin
      result := false
   end else begin
      tmp := Copy(S,AIndex+1, System.Length(AString));
      result := (CompareStr(AString, tmp) = 0);
   end;
end;

end.
 
