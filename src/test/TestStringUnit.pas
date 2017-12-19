unit TestStringUnit;

{$ifdef fpc}
  {$mode objfpc}
  {$h+}
{$endif}

interface

uses
  SysUtils,
{$ifdef fpc}
  fpcunit, testutils, testregistry,
{$else}
  TestFramework,
{$endif}
  TStringUnit;

type
   TTestString = class (TTestCase)
   published
      procedure testCreate;
      procedure testSetString;
      procedure testCase;
      procedure testTrim;
      procedure testCharAt;
      procedure testCompareTo;

      procedure testStringTokenizer;
   end;

implementation

procedure TTestString.testCreate;
var
   str1, str2, str3, str4 : TString;
   arr : array[1..3] of char;
begin
   arr[1] := 'a';
   arr[2] := 'b';
   arr[3] := 'c';
   str1 := TString.Create;
   str2 := TString.Create('test string 2');
   str3 := TString.Create(arr);
   str4 := TString.Create(str3);
   Check(str1.ToString = '', 'String 1 should = ""');
   Check(str2.ToString = 'test string 2', 'String 2 should = "test string 2"');
   Check(str3.ToString = 'abc', 'String 3 should = "abc"');
   Check(str4.ToString = 'abc', 'String 4 should = "abc"');
   str1.Free;
   str2.Free;
   str3.Free;
   str4.Free;
end;

procedure TTestString.testSetString;
var
   str1, str2 : TString;
begin
   str1 := TString.Create;
   str2 := TString.Create('test string 2');
   str1.SetString('abc');
   str2.SetString('def');
   Check(str1.ToString = 'abc', 'String 1 should = "abc"');
   Check(str2.ToString = 'def', 'String 2 should = "def"');
   str1.Free;
   str2.Free;
end;

procedure TTestString.testCase;
var
   str1, str2 : TString;
begin
   str1 := TString.Create('Abc');
   str2 := TString.Create('Def');
   str1.ToUppercase;
   str2.ToLowerCase;
   Check(str1.ToString = 'ABC', 'String 1 should = "ABC"');
   Check(str2.ToString = 'def', 'String 2 should = "def"');
   str1.Free;
   str2.Free;
end;

procedure TTestString.testTrim;
var
   str1, str2 : TString;
begin
   str1 := TString.Create('Abc ');
   str2 := TString.Create(' Def ');
   str1.Trim;
   str2.Trim;
   Check(str1.ToString = 'Abc', 'String 1 should = "Abc"');
   Check(str2.ToString = 'Def', 'String 2 should = "Def"');
   str1.Free;
   str2.Free;
end;

procedure TTestString.testCharAT;
var
   str1, str2 : TString;
begin
   str1 := TString.Create('Abc ');
   str2 := TString.Create(' Def ');
   Check(str1.CharAt(0) = 'A', 'String 1 char at 0 = "A"');
   Check(str2.CharAt(2) = 'e', 'String 2 char at 2 = "e"');
   str1.Free;
   str2.Free;
end;

procedure TTestString.testCompareTo;
var
   str1, str2 : TString;
begin
   str1 := TString.Create('Abc ');
   str2 := TString.Create(' Def ');
   Check(str1.CompareTo('Abc ') = 0, IntToStr(str1.CompareTo('Abc ')));
   Check(str1.CompareTo('aaa') = -32, IntToStr(str1.CompareTo('aaa')));
   Check(str2.CompareToIgnoreCase(' DEF ') = 0, IntToStr(str2.CompareToIgnoreCase(' DEF ')));
   Check(str2.CompareToIgnoreCase('DEF') = -36, IntToStr(str2.CompareToIgnoreCase('DEF')));   
   str1.Free;
   str2.Free;
end;

procedure TTestString.testStringTokenizer;
var
   st : TStringTokenizer;
begin
   st := TStringTokenizer.Create('This is a word tokenizer!',' !',false);
   Check(st <> Nil, 'Tokenizer should not be nil.');
   Check(st.CountTokens = 5, 'Should be 5 tokens, not ' + IntToStr(st.CountTokens));
   Check(st.HasMoreTokens = true, 'Should have more tokens');
   Check(st.NextToken = 'This', 'Token should be "This"');
   Check(st.NextToken = 'is', 'Token should be "is"');
   Check(st.NextToken = 'a', 'Token should be "a"');
   Check(st.NextToken = 'word', 'Token should be "word"');
   Check(st.NextToken = 'tokenizer', 'Token should be "tokenizer"');
   Check(st.HasMoreTokens = false, 'Should have no more tokens');
   st.Free;
end;


initialization
{$ifdef fpc}
  testregistry.RegisterTest(TTestString)
{$else}
  TestFramework.RegisterTest(TTestString.Suite)
{$endif}

end.
 