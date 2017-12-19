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
unit TIBXLogInserterUnit;

interface

uses
  IBDataBase, IBQUERY, TDBLogInserterUnit, TLoggingEventUnit;

type
  TIBXLogInserter = class (TDBLogInserter)
  protected
    FIBDataBase : TIBDataBase;
    FIBTransaction : TIBTransaction;
    FIBQuery : TIBQuery;
  public
    constructor Create(AIBDataBase : TIBDataBase; ASQL : String);
    destructor Destroy; Override;
    procedure Insert(AEvent : TLoggingEvent); Override;
  end;

implementation

uses
  SysUtils, TLogLogUnit;

constructor TIBXLogInserter.Create(AIBDataBase : TIBDataBase; ASQL : String);
begin
  inherited Create;
  Self.FIBDataBase := AIBDataBase;
  Self.FIBTransaction := TIBTransaction.Create(Nil);
  Self.FIBTransaction.DefaultDatabase := Self.FIBDataBase;
  Self.FIBQuery := TIBQuery.Create(Nil);
  Self.FIBQuery.Transaction := Self.FIBTransaction;
  Self.FIBQuery.Database := Self.FIBDataBase;
  Self.FIBQuery.ParamCheck:=true;
  Self.FIBQuery.SQL.Add(ASQL);
end;

destructor TIBXLogInserter.Destroy;
begin
  Self.FIBTransaction.Free;
  Self.FIBQuery.Free;
  inherited Destroy;
end;

procedure TIBXLogInserter.Insert(AEvent : TLoggingEvent);
begin
  if (FIBTransaction.Active) then
    FIBTransaction.Commit;
  FIBTransaction.StartTransaction;

  if Assigned(FIBQuery.Params.FindParam('_msg')) then
  begin
     FIBQuery.ParamByName('_msg').AsString:=AEvent.getMessage;
  end;

  if (AEvent.getException<>nil) then
  begin
   if Assigned(FIBQuery.Params.FindParam('_exception')) then
       FIBQuery.ParamByName('_exception').AsString:=AEvent.getException.Message;
   if Assigned(FIBQuery.Params.FindParam('_exceptionclass')) then
     FIBQuery.ParamByName('_exceptionclass').AsString :=
       AEvent.getException.ClassType.ClassName;
  end;

  if Assigned(FIBQuery.Params.FindParam('_startTime')) then
    FIBQuery.ParamByName('_startTime').AsDateTime := AEvent.getStartTime;

  if Assigned(FIBQuery.Params.FindParam('_level')) then
    FIBQuery.ParamByName('_level').AsString:=AEvent.getLevel.toString;

  if Assigned(FIBQuery.Params.FindParam('_levelCode')) then
    FIBQuery.ParamByName('_levelCode').AsInteger:=AEvent.getLevel.intValue;

  try
    FIBQuery.ExecSQL();
  except
    on e : Exception do
    begin
      TLogLog.fatal('TDbXLogInserter#insert: FIBQuery.ExecSql raised an expeption: '
        + e.message);
    end;
  end;

  FIBQuery.Close;
  FIBTransaction.Commit;
end;

end.
 