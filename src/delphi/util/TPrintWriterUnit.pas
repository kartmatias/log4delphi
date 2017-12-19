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
   Contains the TPrintWriter class.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TPrintWriterUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   Classes;

type
{*----------------------------------------------------------------------------
   Represents a writer that wraps a stream and makes printing to the stream
   easy.
  ----------------------------------------------------------------------------}
   TPrintWriter = class (TObject)
   private
      FStream : TStream;
   public
      constructor Create(AStream : TStream);
      procedure Print(AMsg : String);
      procedure Println(AMsg : String);
      function GetPosition() : Int64;
   end;

implementation

{*----------------------------------------------------------------------------
   Create an instance and use the given stream object.
  ----------------------------------------------------------------------------}
constructor TPrintWriter.Create(AStream : TStream);
begin
   inherited Create;
   Self.FStream := AStream;
end;

{*----------------------------------------------------------------------------
   Print the given message to the stream.
   @param AMsg The message to print
  ----------------------------------------------------------------------------}
procedure TPrintWriter.Print(AMsg : String);
begin
  if (AMsg <> '') then
    // See http://sourceforge.net/projects/log4delphi/forums/forum/486124/topic/3270609
    {$IFDEF UNICODE}
      FStream.Write(PAnsiChar(UTF8String(AMsg))^, Length(UTF8String(AMsg)));
    {$ELSE}
      FStream.Write(PChar(AMsg)^, Length(AMsg));
    {$ENDIF}
end;

{*----------------------------------------------------------------------------
   Print the given message to the stream followed by a newline character.
   @param AMsg The message to print
  ----------------------------------------------------------------------------}
procedure TPrintWriter.Println(AMsg : String);
begin
  if (AMsg <> '') then
    Print(AMsg+#13#10);
end;

function TPrintWriter.GetPosition() : Int64;
begin
  Result := Self.FStream.Position;
end;

end.
 