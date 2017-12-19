unit DCConfiguration;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  Classes;

type
{*----------------------------------------------------------------------------

  ----------------------------------------------------------------------------}
   TAbstractConfiguration = class (TObject)
   private
   protected
   public
     procedure AddProperty(AKey : String; AValue : String); Virtual; Abstract;
     procedure RemoveProperty(AKey : String); Virtual; Abstract;
     procedure Clear(); Virtual; Abstract;

     function ContainsKey(AKey : String) : Boolean; Virtual; Abstract;
     function GetKeys() : TStrings; Virtual; Abstract;
     function IsEmpty() : Boolean; Virtual; Abstract;
     function GetProperty(AKey : String) : String; Virtual; Abstract;

     
   end;

{*----------------------------------------------------------------------------

  ----------------------------------------------------------------------------}
   TBaseConfiguration = class (TAbstractConfiguration)
   private
   protected
     FMap : TStrings;
   public
     constructor Create; Virtual;
     destructor Destroy; Override;

     procedure AddProperty(AKey : String; AValue : String); Override;
     procedure RemoveProperty(AKey : String); Override;
     procedure Clear(); Override;

     function ContainsKey(AKey : String) : Boolean; Override;
     function GetKeys() : TStrings; Override;
     function IsEmpty() : Boolean; Override;
     function GetProperty(AKey : String) : String; Override;
   end;

{*----------------------------------------------------------------------------

  ----------------------------------------------------------------------------}
   TFileConfiguration = class (TBaseConfiguration)
   private
   protected
   public
     procedure Load(AFilename : String); Overload; Virtual;
     procedure Load(AStream : TFileStream); Overload; Virtual;
     procedure Save(AFilename : String); Overload; Virtual;
     procedure Save(AStream : TFileStream); Overload; Virtual;
   end;
   

implementation

{*----------------------------------------------------------------------------
     TBaseConfiguration
  ----------------------------------------------------------------------------}
constructor TBaseConfiguration.Create;
begin
  inherited Create;
  FMap := TStringList.Create;
end;

destructor TBaseConfiguration.Destroy;
begin
  FMap.Free;
  inherited Destroy;
end;

procedure TBaseConfiguration.AddProperty(AKey : String; AValue : String);
begin
  FMap.Add(AKey + '=' + AValue)
end;

procedure TBaseConfiguration.RemoveProperty(AKey : String);
var
  index : Integer;
begin
  index := FMap.IndexOfName(AKey);
  if (index >= 0) then
    FMap.Delete(index);
end;

procedure TBaseConfiguration.Clear();
begin
  FMap.Clear;
end;

function TBaseConfiguration.ContainsKey(AKey : String) : Boolean;
var
  index : Integer;
begin
  index := FMap.IndexOfName(AKey);
  Result := (index >= 0);
end;

function TBaseConfiguration.GetKeys() : TStrings;
var
  res : TStrings;
  count : Integer;
begin
  res := TStringList.Create;
  for count := 0 to FMap.Count-1 do
    res.Add(FMap.Names[count]);
  Result := res;
end;

function TBaseConfiguration.IsEmpty() : Boolean;
begin
  Result := (FMap.Count <= 0);
end;

function TBaseConfiguration.GetProperty(AKey : String) : String;
begin
  Result := '';
  if (Self.ContainsKey(AKey)) then
    Result := FMap.Values[AKey];
end;


{*----------------------------------------------------------------------------
     TFileConfiguration
  ----------------------------------------------------------------------------}
procedure TFileConfiguration.Load(AFilename : String);
begin
  Self.FMap.LoadFromFile(AFilename);
end;

procedure TFileConfiguration.Load(AStream : TFileStream);
begin
  Self.FMap.LoadFromStream(AStream);
end;

procedure TFileConfiguration.Save(AFilename : String);
begin
  Self.FMap.SaveToFile(AFilename);
end;

procedure TFileConfiguration.Save(AStream : TFileStream);
begin
  Self.FMap.SaveToStream(AStream);
end;

end.
