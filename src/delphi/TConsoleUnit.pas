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
unit TConsoleUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  SysUtils, Classes, Controls, Forms,
  {$ifdef fpc}LResources,{$endif} 
  Dialogs, StdCtrls;

type
  TTConsole = class(TForm)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Clear();
    procedure append(const msg : String);
  end;

var
  TConsole: TTConsole;

implementation

{$ifndef fpc}
  {$R *.dfm}
{$endif}

procedure TTConsole.Clear();
begin
   Memo1.Lines.Clear;
end;

procedure TTConsole.append(const msg : String);
begin
   Memo1.Lines.Add(msg);
end;

initialization
{$ifdef fpc}
  {$include tconsoleunit.lrs}
{$endif}

end.
