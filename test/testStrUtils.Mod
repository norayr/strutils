MODULE testStrUtils;
IMPORT Out, strUtils;

PROCEDURE tstExtractWord(i: INTEGER; s: strUtils.string; ch: CHAR);
VAR
  ps: strUtils.pstring;
BEGIN
  Out.String("strUtils.ExtractWord(");
  Out.Int(i, 0);
  Out.String(", '");
  Out.String(s);
  Out.String("', '");
  Out.Char(ch);
  Out.String("') is ");
  ps := strUtils.ExtractWord(i, s, ch);
  Out.String(ps^); Out.Ln;
END tstExtractWord;


PROCEDURE test;
VAR
  s0, s1: strUtils.string;
  ps0, ps1: strUtils.pstring;
  pstrs0 : strUtils.pstrings;
  ch: CHAR;
  i : INTEGER;
BEGIN
  s0 := "manush";
  IF strUtils.contains(s0, "manush") THEN
    Out.String("contains!"); Out.Ln;
  ELSE
    Out.String("doesn't contain."); Out.Ln;
  END;
  strUtils.dumpChars(s0); Out.Ln;
  s0 := "aoeu,htns";
  ch := ",";
  i  := 2;
  Out.String("strUtils.Pos('");
  Out.Char(ch);
  Out.String("', '");
  Out.String(s0);
  Out.String("', ");
  Out.Int(i, 0);
  Out.String("); is ");
  i := strUtils.Pos(ch, s0, i);
  Out.Int(i, 0); Out.Ln;

  s0 := "aoe#;,.#yes#snthd#,,,";
  ch := '#';
  i  := 1; tstExtractWord(i, s0, ch);
  i  := 3; tstExtractWord(i, s0, ch);
  i  := 5; tstExtractWord(i, s0, ch);

  Out.String("strUtils.tokenize('");
  Out.String(s0);
  Out.String("', '");
  Out.Char(ch);
  Out.String("') is"); Out.Ln;
  pstrs0 := strUtils.tokenize(s0, ch);
  FOR i := 0 TO SHORT(LEN(pstrs0^)-1) DO
    Out.String(pstrs0^[i]^); Out.Ln
  END;

  s0 := "manush hangstatsi";
  strUtils.getNextWord(s0, 0, s1);
  Out.String(s1); Out.Ln;

END test;

BEGIN
  test
END testStrUtils.
