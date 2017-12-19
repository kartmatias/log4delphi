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
   Contains the TDBXLogInserter class.
   @version 0.5
   @author <a href="mailto:Bartosz.Tomasik@gmail.com">Bartosz Tomasik</a>
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TDBXLogInserterUnit;

interface

uses
  SqlExpr, TDBLogInserterUnit, TLoggingEventUnit;

type
  TDBXLogInserter = class (TDBLogInserter)
  protected
    FSQLConn : TSQLConnection;
    FSQLQuery : TSQLQuery;
  public
    constructor Create(ASqlConnection: TSQLConnection; ASQL : String);
    destructor Destroy; Override;
    procedure Insert(AEvent : TLoggingEvent); Override;
  end;

implementation

uses
  SysUtils, SqlTimSt, TLogLogUnit;

constructor TDBXLogInserter.Create(ASqlConnection: TSQLConnection; ASQL : String);
begin
  inherited Create;
  FSqlConn := ASqlConnection;
  FSQLQuery := TSQLQuery.Create(Nil);
  FSQLQuery.SQLConnection:=self.FsqlConn;
  FSQLQuery.ParamCheck:=true;
  FSQLQuery.SQL.Add(ASQL);
end;

destructor TDBXLogInserter.Destroy;
begin
  FSQLQuery.Free;
  inherited Destroy;
end;

procedure TDBXLogInserter.Insert(AEvent : TLoggingEvent);
begin
  if not Assigned(FSqlConn) then
  begin
     TLogLog.debug('TDBXLogInserter#Insert: SqlConnection not Assigned');
     exit;
  end;

  try
    FSqlConn.Open;
  except
    on e : Exception do
    begin
      TLogLog.fatal('TDBXLogInserter#Insert: SqlConnection.Open raised an expeption: '
        + e.message);
      exit;
    end;
  end;

  if Assigned(FSQLQuery.Params.FindParam('_msg')) then
  begin
     FSQLQuery.ParamByName('_msg').AsString:=AEvent.getMessage;
  end;

  if (AEvent.getException<>nil) then
  begin
   if Assigned(FSQLQuery.Params.FindParam('_exception')) then
       FSQLQuery.ParamByName('_exception').AsString:=AEvent.getException.Message;
   if Assigned(FSQLQuery.Params.FindParam('_exceptionclass')) then
     FSQLQuery.ParamByName('_exceptionclass').AsString :=
       AEvent.getException.ClassType.ClassName;
  end;

  if Assigned(FSQLQuery.Params.FindParam('_startTime')) then
    FSQLQuery.ParamByName('_startTime').AsSQLTimeStamp :=
      DateTimeToSQLTimeStamp(AEvent.getStartTime);

  if Assigned(FSQLQuery.Params.FindParam('_level')) then
    FSQLQuery.ParamByName('_level').AsString:=AEvent.getLevel.toString;

  if Assigned(FSQLQuery.Params.FindParam('_levelCode')) then
    FSQLQuery.ParamByName('_levelCode').AsInteger:=AEvent.getLevel.intValue;

  try
    FSQLQuery.ExecSQL();
  except
    on e : Exception do
    begin
      TLogLog.fatal('TDbXLogInserter#insert: FSQLQuery.ExecSql raised an expeption: '
        + e.message);
    end;
  end;

  FSQLQuery.Close;
end;

end.
 