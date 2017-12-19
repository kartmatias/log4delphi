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
unit TBDELogInserterUnit;

interface

uses
  DBTables, TDBLogInserterUnit, TLoggingEventUnit;

type
  TBDELogInserter = class (TDBLogInserter)
  protected
    FDatabase : TDatabase;
    FQuery : TQuery;
  public
    constructor Create(ADatabase: TDatabase; ASQL : String);
    destructor Destroy; Override;
    procedure Insert(AEvent : TLoggingEvent); Override;
  end;

implementation

uses
  SysUtils, TLogLogUnit;

constructor TBDELogInserter.Create(ADatabase: TDatabase; ASQL : String);
begin
  inherited Create;
  FDatabase := ADatabase;
  FQuery := TQuery.Create(Nil);
  FQuery.DatabaseName := FDatabase.DatabaseName;
  FQuery.ParamCheck:=true;
  FQuery.SQL.Add(ASQL);
end;

destructor TBDELogInserter.Destroy;
begin
  FQuery.Free;
  inherited Destroy;
end;

procedure TBDELogInserter.Insert(AEvent : TLoggingEvent);
begin
  if not Assigned(FDatabase) then
  begin
     TLogLog.debug('TBDELogInserter#Insert: Database not Assigned');
     exit;
  end;

  try
    FDatabase.Open;
  except
    on e : Exception do
    begin
      TLogLog.fatal('TDBXLogInserter#Insert: SqlConnection.Open raised an expeption: '
        + e.message);
      exit;
    end;
  end;

  if Assigned(FQuery.Params.FindParam('_msg')) then
  begin
     FQuery.ParamByName('_msg').AsString:=AEvent.getMessage;
  end;

  if (AEvent.getException<>nil) then
  begin
   if Assigned(FQuery.Params.FindParam('_exception')) then
       FQuery.ParamByName('_exception').AsString:=AEvent.getException.Message;
   if Assigned(FQuery.Params.FindParam('_exceptionclass')) then
     FQuery.ParamByName('_exceptionclass').AsString :=
       AEvent.getException.ClassType.ClassName;
  end;

  if Assigned(FQuery.Params.FindParam('_startTime')) then
    FQuery.ParamByName('_startTime').AsDateTime := AEvent.getStartTime;

  if Assigned(FQuery.Params.FindParam('_level')) then
    FQuery.ParamByName('_level').AsString:=AEvent.getLevel.toString;

  if Assigned(FQuery.Params.FindParam('_levelCode')) then
    FQuery.ParamByName('_levelCode').AsInteger:=AEvent.getLevel.intValue;

  try
    FQuery.ExecSQL();
  except
    on e : Exception do
    begin
      TLogLog.fatal('TDbXLogInserter#insert: FQuery.ExecSql raised an expeption: '
        + e.message);
    end;
  end;

  FQuery.Close;
end;

end.
