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
   Contains the TProperties class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TPropertiesUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   Classes, SysUtils,
   TStringUnit, TPrintWriterUnit;

type
{*----------------------------------------------------------------------------
   TProperties represents a persistent set of properties that can be saved to
   a TStream or loaded from a TStream. A property is simply a key=value
   mapping between two strings, one the key and the other the value.
   <p>
   Properties are saved to stream as key=value, one such pair per line, and
   when loaded from a stream, the same format is expected. Keys can be of the
   form "base.name" thus allowing a subset of all properties with the same
   base to be found.
  ----------------------------------------------------------------------------} 
   TProperties = class (TObject)
   private
      FValues : TStrings;
   public
      constructor Create;
      destructor Destroy; Override;
      procedure SetProperty(const AKey, AValue : String);
      procedure RemoveProperty(const AKey : String);
      procedure Save(AStream : TStream);
      procedure Load(AStream : TStream);
      procedure Clear();
      function GetProperty(const AKey : String) : String; Overload;
      function GetProperty(const AKey, ADefaultValue : String)
        : String; Overload;
      function GetPropertyNames() : TStrings;
      function Subset(const APrefix : String) : TProperties;
   end;

implementation

{*----------------------------------------------------------------------------
   Instantiate a Properties instance with an empty properties set.
  ----------------------------------------------------------------------------}
constructor TProperties.Create;
begin
   inherited Create;
   FValues := TStringList.Create;
end;

{*----------------------------------------------------------------------------
   Destruct the instance by freeing the internal properties set.
  ----------------------------------------------------------------------------}
destructor TProperties.Destroy;
begin
   clear();
   FValues.Free;
   inherited Destroy;
end;

{*----------------------------------------------------------------------------
   Set a property in the set.
   @param AKey The key to set
   @param AValue The value that maps to that key
  ----------------------------------------------------------------------------}
procedure TProperties.SetProperty(const AKey, AValue : String);
var
   index : Integer;
begin
   index := FValues.IndexOf(AKey);
   if (index < 0) then begin
      FValues.AddObject(AKey, TString.Create(AValue));
   end else begin
      TString(FValues.Objects[index]).setString(AValue);
   end;
end;

{*----------------------------------------------------------------------------
   Remove the value that maps to the given key. Does nothing if the key is
   non-existent, no such key in the set.
   @param AKey The key whose value to delete
  ----------------------------------------------------------------------------}
procedure TProperties.RemoveProperty(const AKey : String);
var
   index : Integer;
begin
   index := FValues.IndexOf(AKey);
   if (index >= 0) then begin
      FValues.Objects[index].Free;
      FValues.Delete(index);
   end;
end;

{*----------------------------------------------------------------------------
   Save the set of properties to a stream. This can be any class that
   subclasses TStream.
   @param AStream The TStream to save to
  ----------------------------------------------------------------------------}
procedure TProperties.Save(AStream : TStream);
var
   writer : TPrintWriter;
   index : Integer;
begin
   writer := TPrintWRiter.Create(AStream);
   for index := 0 to FValues.Count-1 do begin
      writer.print(FValues[index]);
      writer.print('=');
      writer.println(TString(FValues.Objects[index]).ToString);
   end;
   writer.Free;
end;

{*----------------------------------------------------------------------------
   Load a properties set from a stream. This can be any class that subclasses
   TStream.
   @param AStream The stream to load from
  ----------------------------------------------------------------------------}
procedure TProperties.Load(AStream : TStream);
var
   strings : TStrings;
   count : Integer;
   index : Integer;
begin
   clear();
   strings := TStringList.Create;
   strings.LoadFromStream(AStream);
   for count := 0 to strings.Count-1 do begin
      if (Length(strings[count]) > 0) then
         if (strings[count][1] <> '#') then begin
            index := Pos('=', strings[count]);
            if (index >= 0) then begin
               FValues.AddObject(trim(copy(strings[count],0,index-1)),
                  TString.Create(trim(copy(strings[count],index+1,
                  Length(strings[count])-index))));
            end;
         end;
   end;
   strings.Free;
end;

{*----------------------------------------------------------------------------
   Clear the properties set.
  ----------------------------------------------------------------------------}
procedure TProperties.Clear();
var
   count : Integer;
begin
   for count := 0 to FValues.Count-1 do
      FValues.Objects[count].Free;
   FValues.Clear;
end;

{*----------------------------------------------------------------------------
   Return a property matching the given key. If no such key exists in the
   properties set then the empty string '' is returned.
   @param AKey The key whose value to return
   @return The value matching the given key or an emprty string if no such
     key exists
  ----------------------------------------------------------------------------}
function TProperties.GetProperty(const AKey : String) : String;
begin
   result := getProperty(Akey, '');
end;

{*----------------------------------------------------------------------------
   Return a property matching the given key. If no such key exists in the
   properties set then the default value is returned.
   @param AKey The key whose value to return
   @param ADefaultValue The default value to use
   @return The value matching the given key or default value if no such
     key exists
  ----------------------------------------------------------------------------}
function TProperties.GetProperty(const AKey, ADefaultValue : String) : String;
var
   index : Integer;
begin
   index := FValues.IndexOf(AKey);
   if (index >= 0) then
      result := TString(FValues.Objects[index]).toString
   else
      result := ADefaultValue;
end;

{*----------------------------------------------------------------------------
   Return a list of all the property keys in the set. This can be used for
   iterating through all the properties in the set.
   @return TStringList with all the keys 
  ----------------------------------------------------------------------------}
function TProperties.GetPropertyNames() : TStrings;
var
   tmp : TStrings;
begin
   tmp := TStringList.Create;
   tmp.Text := FValues.Text;
   result := tmp;
end;

{*----------------------------------------------------------------------------
   Return a subset of properties whose keys match a given base prefix. It is
   possible that none of the keys match the base prefix, in such a case, an
   empty properties set will be returned. It is the caller's responsibility to
   free the memory of the returned TProperties instance.
   @param APrefix The base prefix of the subset
   @return A new TProperteis instance containing the subset of properties
  ----------------------------------------------------------------------------}
function TProperties.Subset(const APrefix : String) : TProperties;
var
   tmp : TProperties;
   i : Integer;
begin
   tmp := TProperties.Create;
   for i := 0 to FValues.Count-1 do
      if (TStringUnit.StartsWith(FValues[i], APrefix, 0)) then
         tmp.FValues.AddObject(FValues[i],
           TString.Create(TString(FValues.Objects[i])));
   result := tmp;
end;

end.
 