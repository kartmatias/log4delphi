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
   Contains the configuration procedures used to configure the Log4Delphi
   package from a properties file.
   @version 0.5
   @author <a href="mailto:tcmiller@users.sourceforge.net">Trevor Miller</a>
  ----------------------------------------------------------------------------}
unit TPropertyConfiguratorUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
   TPropertiesUnit;

const LOGGER_PREFIX = 'log4delphi.logger.';
const ROOT_LOGGER_PREFIX = 'log4delphi.rootLogger';
const APPENDER_PREFIX = 'log4delphi.appender.';
const THRESHOLD_PREFIX = 'log4delphi.threshold';
const DEBUG_KEY = 'log4delphi.debug';

procedure DoConfigure(const AFilename : String); Overload;
procedure DoConfigure(const AProps : TProperties); Overload;

implementation

uses
   SysUtils, Classes, Forms,
   TLogLogUnit, TLoggerUnit, TLevelUnit, TStringUnit, TOptionConverterUnit,
   TAppenderUnit, TFileAppenderUnit, TLayoutUnit, TSimpleLayoutUnit,
   THTMLLayoutUnit, TXMLLayoutUnit, TPatternLayoutUnit, TRollingFileAppenderUnit;

var
   registry : TAppendersCollection;

function InstantiateAppender(AName : String; AProps : TProperties;
   APrefix : String) : IAppender;
var
   appender : TAppender;
   tmp : String;
   appdir : boolean;
begin
   TLogLog.debug('InstantiateAppender: ' + AName + ', ' + APrefix);
   appender := nil;

   // deal with file appender
   if (Pos('FileAppender',AName) > 0) then begin
      appdir := false;
      if (CompareText(AName, 'TFileAppender') = 0) then begin
        appender := TFileAppender.Create;
        TLogLog.debug('TFileAppender created.');
      end else if (CompareText(AName, 'TRollingFileAppender') = 0) then begin
        appender := TRollingFileAppender.Create;
        TLogLog.debug('TRollingFileAppender created.');

        tmp := AProps.GetProperty(APrefix + '.MaxBackupIndex');
        if (tmp <> '') then begin
           TRollingFileAppender(appender).SetMaxBackupIndex(StrToInt(tmp));
           TLogLog.debug(AName+' - MaxBackupIndex');
        end;
        tmp := AProps.GetProperty(APrefix + '.MaxFileSize');
        if (tmp <> '') then begin
           TRollingFileAppender(appender).SetMaxFileSize(tmp);
           TLogLog.debug(AName+' - MaxFileSize');
        end;        

      end;
      tmp := AProps.GetProperty(APrefix + '.Append');
      if (CompareText(tmp,'true') = 0) then begin
         TFileAppender(appender).setAppend(true);
         TLogLog.debug(AName+' - Append');
      end;
      tmp := AProps.GetProperty(APrefix + '.AppDir');
      if (CompareText(tmp,'true') = 0) then begin
        appdir := true;
        TLogLog.debug(AName+' - AppDir');
      end;
      tmp := AProps.GetProperty(APrefix + '.File');
      if (tmp <> '') then
        if (appdir) then begin
          TFileAppender(appender).setFile(ExtractFileDir(Application.ExeName)
            + '\' + tmp);
            TLogLog.debug(AName+' - ' + ExtractFileDir(Application.ExeName)
            + '\' + tmp);
        end else begin
          TFileAppender(appender).setFile(tmp);
          TLogLog.debug(AName+' - ' + tmp);
        end;
   end;

   result := appender;
end;

function InstantiateLayout(AName : String; AProps : TProperties;
   APrefix : String) : TLayout;
var
   layout : TLayout;
   tmp : STring;
begin
   TLogLog.debug('InstantiateLayout: ' + AName + ', ' + APrefix);
   result := Nil;
   if (CompareText(AName, 'TSimpleLayout') = 0) then
      result := TSimpleLayout.Create;
   if (CompareText(AName, 'THTMLLayout') = 0) then begin
      layout := THTMLLayout.Create;
      tmp := AProps.GetProperty(Aprefix + '.Title');
      TLogLog.debug('InstantiateLayout tmp=' +tmp);
      if (tmp <> 'InstantiateLayout') then
         THTMLLayout(layout).setTitle(tmp);
      result := layout;
   end;
   if (CompareText(AName, 'TXMLLayout') = 0) then
      result := TXMLLayout.Create;
   if (CompareText(AName, 'TPatternLayout') = 0) then begin
      tmp := AProps.GetProperty(Aprefix + '.Pattern');
      result := TPatternLayout.Create(tmp);
   end;
end;

function ParseAppender(AProps : TProperties; AName : String) : IAppender;
var
   appender : IAppender;
   layout : TLayout;
   prefix : String;
   layoutPrefix : String;
begin
   appender := registry.FindByName(AName);
   if (appender <> nil) then begin
      result := appender;
      exit;
   end;
   prefix := APPENDER_PREFIX + AName;
   layoutPrefix := prefix + '.layout';
   appender := InstantiateAppender(AProps.GetProperty(prefix),
      AProps, prefix);
   if (appender = Nil) then begin
       TLogLog.error('Could not instantiate appender named "'
          + AName + '".');
       result := Nil;
       exit;
   end;
   appender.setName(AName);

   if (appender.requiresLayout) then begin
      layout := InstantiateLayout(AProps.GetProperty(layoutPrefix), AProps, layoutPrefix);
      if (layout <> Nil) then begin
         appender.setLayout(layout);
         TLogLog.debug('Set layout for "' + AName + '".');
      end;
   end;

   TLogLog.debug('Parsed "' + AName + '" options.');
   registry.Add(appender);
   result := appender;
end;

procedure ParseLogger(const AProps : TProperties; ALogger : TLogger;
   const AKey : String; const ALoggerName : String; const AValue : String);
var
   tokenizer : TStringTokenizer;
   appender : IAppender;
   appenderName : String;
   levelStr : String;
begin
   TLogLog.debug('Parsing for [' +ALoggerName +'] with value=[' + AValue + '].');
   tokenizer := TStringTokenizer.Create(AValue, ',');
   if (not ((StartsWith(AValue,',',0)) OR (AValue = ''))) then begin
      if (not tokenizer.HasMoreTokens) then
         exit;
      levelStr := Trim(tokenizer.NextToken);
      TLogLog.debug('Level token is [' + levelStr + '].');
      if (levelStr <> '') then
         ALogger.setLevel(TLevelUnit.toLevel(levelStr));
      TLogLog.info('Category ' + ALoggerName + ' set to ' + ALogger.getLevel().toString);
   end;
   ALogger.removeAllAppenders;
   while (tokenizer.HasMoreTokens) do begin
      appenderName := Trim(tokenizer.NextToken);
      if ((appenderName <> '') AND (appenderName <> ',')) then begin
         TLogLog.debug('Parsing appender named "' + appenderName +'".');
         appender := parseAppender(AProps, appenderName);
         if(appender <> Nil) then
            ALogger.addAppender(appender);
      end;
   end; 
   tokenizer.Free;
end;

procedure ParseLoggers(const AProps : TProperties);
var
   propNames : TStrings;
   i : Integer;
   key : TString;
   loggerName : TString;
   value : String;
begin
   propNames := AProps.GetPropertyNames;
   key := TString.Create;
   for i :=0 to propNames.Count-1 do begin
      key.setString(propNames[i]);
      if (key.startsWith(LOGGER_PREFIX)) then begin
         loggerName := key.substring(Length(LOGGER_PREFIX)+1);
         value := TOptionConverter.FindAndSubst(key.ToString, AProps);
         ParseLogger(AProps, TLogger.getInstance(loggerName.toString), key.toString, loggerName.toString, value);
         loggerName.Free;
      end;
   end;
   key.Free;
   propNames.Free;
end;

procedure ConfigureRootLogger(const AProps : TProperties);
var
   value : String;
begin
   TLogLog.info('Configuring root logger.');
   value := TOptionConverter.FindAndSubst(ROOT_LOGGER_PREFIX, AProps);
   if (value = '') then
      TLogLog.debug('Could not find root logger information.')
   else begin
      ParseLogger(AProps, TLogger.getInstance, ROOT_LOGGER_PREFIX, 'ROOT', value);
   end;
end;

procedure DoConfigure(const AProps : TProperties);
var
   value : String;
begin
   registry := TAppendersCollection.Create;
   value := AProps.GetProperty(DEBUG_KEY);
   if (CompareText(value,'true') = 0) then
      TlogLogUnit.initialize(GetCurrentDir + '\log4delphi.log');
   value := AProps.GetProperty(THRESHOLD_PREFIX);
   TLoggerUnit.setDefaultThreshold(TLevelUnit.toLevel(value));
   ConfigureRootLogger(AProps);
   ParseLoggers(AProps);
   registry.Free;
   TLogLog.debug('Finished configuring.');
end;

procedure DoConfigure(const AFilename : String);
var
   props : TProperties;
   fin : TFileStream;
begin
   props := TProperties.Create;
   try
      fin := TFileSTream.Create(AFileName, fmOpenRead);
      props.Load(fin);
      fin.Free;
      DoConfigure(props);
   except
      on E: Exception do begin
         TLogLog.error('Could not read configuration file ['
            + AFileName + '] ' + e.Message);
         TLogLog.error('Ignoring configuration file [' + AFilename + ']');
      end;
   end;
   props.Free;
end;

end.
 