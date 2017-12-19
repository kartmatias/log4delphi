{
   Copyright 2005-2010 Log4Delphi Project

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
   Contains the configuration procedures used to configure the Log4Delphi
   package from a ini file section.
   @version 0.5
   @author <a href="mailto:vsevolodp@gmail.com">Vsevolod Parfenov</a>
  ----------------------------------------------------------------------------}
unit TIniConfiguratorUnit;

interface

uses
   Classes, SysUtils, IniFiles,
   TPropertiesUnit, TPropertyConfiguratorUnit, TLogLogUnit;

procedure DoConfigure(const AFilename, ASectionName : String);

implementation

procedure DoConfigure(const AFilename, ASectionName : String);
var
   props : TProperties;
   fin : TIniFile;
   sl: TStringList;
   i: Integer;
   value: String;
begin
   props := TProperties.Create;
   fin := TIniFile.Create(AFilename);
   sl := TStringList.Create();
   try
      try
         fin.ReadSection(ASectionName, sl);

         for i := 0 to sl.Count - 1 do
         begin
            value := fin.ReadString(ASectionName, sl[i], '');
            props.SetProperty(sl[i], value);
         end;

         TPropertyConfiguratorUnit.DoConfigure(props);
      except
         on E: Exception do begin
            TLogLog.error('Could not read configuration file ['
               + AFileName + '] ' + e.Message);
            TLogLog.error('Ignoring configuration file [' + AFilename + ']');
         end;
      end;
   finally
      props.Free;
      fin.Free;
      sl.Free;
   end;
end;

end.
