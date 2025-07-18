MODULE strUtils;
IMPORT Ascii := oocAscii, S := strTypes, Strings := ooc2Strings, Out;

CONST
  CR* = 0DX;
  LF* = 0AX;

 TYPE string* = S.string;
      strings* = S.strings;
      pstring* = S.pstring;
      pstrings*= S.pstrings;

(** from the oo2c Strings module, implements string comparison, which should be implemented in a library level in case of Oberon-1 *)
TYPE  CompareResults* = SHORTINT;
  (**Result type of @oproc{Compare}.  *)

CONST
  (**Result of @oproc{Compare} if the first argument is lexically less than the second one.  *)
  less* = -1;
  (**Result of @oproc{Compare} if the first argument is equal to the second one.  *)
  equal* = 0;
  (**Result of @oproc{Compare} if the first argument is lexically greater than the second one.  *)
  greater* = 1;

(** this function copied from ooc source and may be considered a duplicate.$
   Returns @oconst{less}, @oconst{equal}, or @oconst{greater}, according as
   @oparam{stringVal1} is lexically less than, equal to, or greater than
   @oparam{stringVal2}.  Note that Oberon-2 and Oberon-07 already contains predefined comparison operators on strings.  *)
 PROCEDURE Compare* (stringVal1, stringVal2: ARRAY OF CHAR): CompareResults;
  VAR
    i: INTEGER;
  BEGIN
    i := 0;
    WHILE (stringVal1[i] # 0X) & (stringVal1[i] = stringVal2[i]) DO
      INC (i)
    END;
    IF (stringVal1[i] < stringVal2[i]) THEN
      RETURN less
    ELSIF (stringVal1[i] > stringVal2[i]) THEN
      RETURN greater
    ELSE
      RETURN equal
    END
  END Compare;

(**Copies @oparam{source} to @oparam{destination}.  Equivalent to the
   predefined procedure @code{COPY}.  Unlike @code{COPY}, this procedure can be
   assigned to a procedure variable.  *)

PROCEDURE Assign* (source: ARRAY OF CHAR; VAR destination: ARRAY OF CHAR);
  VAR
    i: INTEGER;
  BEGIN
    i := -1;
    REPEAT
      INC (i);
      destination[i] := source[i]
    UNTIL (destination[i] = 0X) OR (i = LEN (destination)-1);
    destination[i] := 0X
  END Assign;

PROCEDURE Pos* (substr : CHAR ; s : ARRAY OF CHAR; n : INTEGER) : INTEGER;
VAR
  i : INTEGER;
BEGIN
  FOR i := n TO Strings.Length(s) DO
    IF s[i] = substr THEN RETURN(i) END;
  END;
  RETURN(0);
END Pos;

PROCEDURE RemoveLeftChars* (VAR s : ARRAY OF CHAR; ch : CHAR);
BEGIN
REPEAT
IF s[0] = ch THEN Strings.Delete (s, 0, 1) END;

UNTIL s[0] # ch;

END RemoveLeftChars;

PROCEDURE RemoveRightChars* (VAR s : ARRAY OF CHAR; ch : CHAR);
VAR l : INTEGER;
BEGIN
l := Strings.Length(s);
REPEAT

IF s[l] = ch THEN Strings.Delete (s, l, 1) END;
DEC(l);
UNTIL s[l] # ch;

END RemoveRightChars;

(** Returns the number of substrings (words) in s separated by character ch. *)

PROCEDURE WordCount* (s : ARRAY OF CHAR; ch : CHAR) : INTEGER;
VAR
  k,l : INTEGER;
BEGIN
  RemoveLeftChars(s, ch);
  RemoveRightChars (s, ch);
  k := 0;
  l := 0;
  REPEAT
    IF s[l] = ch THEN
      INC(k);
      REPEAT
        INC(l);
      UNTIL s[l] # ch;
    END;
    INC(l);
  UNTIL l = Strings.Length(s);
  INC(k);
  RETURN(k);
END WordCount;

(** Counts and returns the number of times character ch appears in string s. *)

PROCEDURE NumberOfChar* (s : ARRAY OF CHAR; ch : CHAR) : LONGINT;
VAR
  n, i : LONGINT;
BEGIN
  n := 0;
  FOR i := 0 TO Strings.Length(s) DO
    IF s[i] = ch THEN INC(n) END;
  END;
  RETURN(n);
END NumberOfChar;

(** Returns the rightmost index of character ch in string s; if not found, returns 0. *)

PROCEDURE Rpos* ( s : ARRAY OF CHAR ; ch : CHAR) : INTEGER;
VAR
  l : INTEGER;
BEGIN
  l := Strings.Length (s);
  IF s[l] = ch THEN RETURN(l) END;
  REPEAT
    DEC(l);
  UNTIL (s[l] = ch) OR (l = 0);
  RETURN(l);
END Rpos;

(** Returns the leftmost index of character ch in string s; if not found, returns 0. *)

PROCEDURE Lpos* ( s : ARRAY OF CHAR ; ch : CHAR) : INTEGER;
VAR
  l : INTEGER;
BEGIN
  l := 0;
  IF s[l] = ch THEN RETURN(l) END;
  REPEAT
    INC(l);
    IF s[l] = ch THEN RETURN(l) END;
  UNTIL l = Strings.Length(s);
  RETURN(0);
END Lpos;

(** Appends extra to destination, allocating or resizing destination as needed. *)

PROCEDURE append*(VAR extra, destination: pstring);
VAR
  tmp: pstring;
BEGIN
  IF extra # NIL THEN
       (*  Out.String("extra='"); Out.String(extra^); Out.Char("'"); Out.Ln; *)
    IF destination = NIL THEN
            Out.String("dest is nil"); Out.Ln;
      NEW(destination, Strings.Length(extra^)+1);
      COPY(extra^, destination^);
       (*  Out.String("now dest is '"); Out.String(destination^); Out.Char("'"); Out.Ln; *)
    ELSE
       (* Out.String("dest is not nil, it's '");Out.String(destination^);Out.Char("'");Out.Ln; *)
      NEW(tmp, Strings.Length(extra^) + Strings.Length(destination^)+1);
      COPY(destination^, tmp^);
           (* Out.String("copied dest to tmp, tmp is '"); Out.String(tmp^); Out.Char("'"); Out.Ln; *)
      Strings.Append(extra^, tmp^);
            (* Out.String("after appending tmp is '"); Out.String(tmp^); Out.Char("'"); Out.Ln; *)
      NEW(destination, Strings.Length(tmp^)+1);
      COPY(tmp^, destination^);
    END;
           (* Out.String("now dest is '"); Out.String(destination^); Out.Char("'"); Out.Ln; *)
  END
END append;

(** Copies up to quantity characters from src into dst, starting at index start. *)

PROCEDURE copyBytes*(VAR src, dst: ARRAY OF CHAR; start, quantity: LONGINT);
VAR
  i, j : LONGINT;
BEGIN
  i := start; j := 0;
  IF i < (LEN(dst)-1) THEN
     REPEAT
       dst[i] := src[j];
       INC(i); INC(j);
     UNTIL (i = LEN(dst)) OR (j = LEN(src)) OR (j = quantity);
  END
END copyBytes;

(** Appends extraNum characters from extra to destinationNum characters of destination, reallocating destination. *)

PROCEDURE appendNumChars*(VAR extra: pstring; extraNum: LONGINT; VAR destination: pstring; destinationNum: LONGINT);
VAR
  tmp: pstring;
BEGIN
  IF extra # NIL THEN
    IF destination = NIL THEN
      NEW(destination, extraNum);
      copyBytes(extra^, destination^, 0, extraNum);
    ELSE
      NEW(tmp, extraNum + destinationNum);
      copyBytes(destination^, tmp^, 0, destinationNum);
      copyBytes(extra^, tmp^, destinationNum, extraNum);
      NEW(destination, LEN(tmp^));
      copyBytes(tmp^, destination^, 0, LEN(tmp^));
    END;
  END
END appendNumChars;

(** Allocates and assigns the contents of string s to the pstring d. *)

PROCEDURE string2pstring*(s: ARRAY OF CHAR; VAR d : pstring);
BEGIN
  NEW(d, Strings.Length(s)+1);
  Assign (s, d^);
END string2pstring;

(** Converts a CHAR array into a dynamic array of pstrings, one per line. *)

PROCEDURE string2pstrings*(VAR text: ARRAY OF CHAR): pstrings;
VAR
  i, j, lineNum, start, number: INTEGER;
  pstrs: pstrings;
  pstr:  pstring;
BEGIN
  i := 0;
  j := 0;
  REPEAT
    IF text[i] = 0AX THEN INC(j) END;
    INC(i);
  UNTIL (i = LEN(text)) OR (text[i] = 0X); (* now in j we have number of lines *)
  (* and in i we have position of the end of the text *)
  NEW(pstrs, j); (*creating ptsrs array with that count *)
  lineNum := 0;         (* current line number, will inc until j*)
  number := 0;    (* character index in the text *)
  REPEAT            (* now we have to fill it line by line *)
    WHILE (text[number] = 0AX) OR (text[number] = 0DX) DO INC(number) END;
    start := number;

    REPEAT
      INC(number)
    UNTIL (number = LEN(text) - 1) OR (text[number] = 0AX)
         OR (text[number] = 0DX) OR (text[number] = 0X); (* reached eol *)

    NEW(pstr, number - start + 1);
    Strings.Extract(text, start, number - start, pstr^);
    pstrs^[lineNum] := pstr;
    INC(lineNum);
  UNTIL (lineNum = j) OR (number = i);
  RETURN pstrs
END string2pstrings;

(** Returns the n-th substring from s, split by separator ch, as a pstring. *)

PROCEDURE ExtractWord* (n : INTEGER; s : ARRAY OF CHAR; ch : CHAR) : pstring;
VAR
  i, j, k, l : INTEGER;
  str : string;
  pstr : pstring;
BEGIN
  RemoveLeftChars (s, ch);
  RemoveRightChars (s, ch);
  IF n = WordCount (s, ch) THEN
    l := Rpos (s, ch);
    Strings.Extract (s, l+1, Strings.Length(s)-l-1, str);
    string2pstring(str, pstr);
    RETURN (pstr);
  ELSIF n = 1 THEN
    l := Lpos(s, ch);
    Strings.Extract (s, 0, l, str);
    string2pstring(str, pstr);
    RETURN (pstr);
  ELSE
    j := 0;
    k := 0;
    l := 0;
    i := 0;
    REPEAT
      IF s[i] = ch THEN
        INC(j) ;
        IF j = (n-1) THEN k := i  END;
        IF j = n THEN l := i END;
      END;
      INC(i);
    UNTIL i = Strings.Length(s);
    Strings.Extract(s, k+1, l-k-1, str);
    string2pstring(str, pstr);
    RETURN (pstr)
    END
END ExtractWord;

(** Outputs a detailed dump of string s: index, ordinal value, and character. *)

PROCEDURE dumpStr*(s: ARRAY OF CHAR);
VAR
  i, j : INTEGER;
BEGIN
  i := 0; j := Strings.Length(s);
  REPEAT
    Out.Int(i, 0); Out.String("   "); Out.Int(ORD(s[i]), 0); Out. String("   "); Out.Char(s[i]); Out.Ln;
    INC(i)
  UNTIL i = j;
END dumpStr;

(** Returns an array of pstrings by splitting s on separator ch. *)

PROCEDURE tokenize*(s : ARRAY OF CHAR; ch : CHAR) : pstrings;
VAR
  pstr  : pstring;
  pstrs : pstrings;
  l, n : INTEGER;
BEGIN
  n := WordCount(s, ch);
  IF n # 0 THEN
    NEW (pstrs, n)
  ELSE
    pstrs := NIL;
    RETURN pstrs
  END;
  IF n = 1 THEN
    RemoveRightChars (s, ch);
    RemoveLeftChars (s, ch);
    string2pstring(s, pstrs^[0]);
  ELSE
    l := 0;
    REPEAT
      pstr := ExtractWord ( l+1, s, ch);
      pstrs^[l] := pstr;
      INC(l);
    UNTIL l = n;
  END;
  RETURN pstrs
END tokenize;

(** Copies up to LEN(dst)-1 chars from src to dst, including data past 0X, and null-terminates dst. *)


PROCEDURE copyAll* (src : ARRAY OF CHAR ; VAR dst : ARRAY OF CHAR);
VAR i, k : LONGINT;
BEGIN
  IF LEN (src) < LEN(dst) THEN k := LEN(src) ELSE k := LEN(dst)  END;
  FOR i := 0 TO k-2 DO
    dst[i] := src[i];
  END;
  dst[k-1] := 0X;
END copyAll;

(** fills whole array with zeroes, useful when one needs to get several strings which contain characters < ' ' and not necessarily end with 0X *)
PROCEDURE zeroStr*(VAR str: ARRAY OF CHAR);
VAR
  i, j : LONGINT;
BEGIN
  i := LEN(str);
  j := 0;
  REPEAT
    str[j] := 0X;
    INC(j)
  UNTIL j = i;
END zeroStr;

(** Appends LF and CR characters to str and updates the null terminator. *)

PROCEDURE appendLFCR*(VAR str: ARRAY OF CHAR);
VAR
  l : INTEGER;
BEGIN
        l := Strings.Length(str);
        str[l] := LF;
        str[l+1] := CR;
        str[l+2] := 0X;
END appendLFCR;

(** Finds first occurrence of ch in line; returns position in pos and found flag in b. *)

PROCEDURE findChar*(ch: CHAR; VAR line: ARRAY OF CHAR; VAR b: BOOLEAN; VAR pos: INTEGER);
VAR
  i : INTEGER;
BEGIN
  i := -1; pos := -1;
  b := FALSE;
  REPEAT
    INC(i);
    IF line[i] = ch THEN b := TRUE; pos := i END;
  UNTIL b OR (i = LEN(line) - 1);
END findChar;

(** Extracts the line from src up to the first LF character and stores it in dst. *)

PROCEDURE cutLine*(VAR src, dst: ARRAY OF CHAR);
VAR
 found: BOOLEAN;
 pos : INTEGER;
 i : INTEGER;
BEGIN
  COPY("", dst);
  findChar(LF, src, found, pos);
  IF found THEN
    i := 0;
    REPEAT
      dst[i] := src[i];
      INC(i);
    UNTIL (i = pos) OR (i = LEN(dst)-2);
    dst[i] := src[i];
    dst[i+1] := 0X
  END;
END cutLine;

(** Terminates str immediately after the first LF by inserting 0X, preserving the LF itself. *)

PROCEDURE terminateLine*(VAR str: ARRAY OF CHAR);
VAR
 found: BOOLEAN;
 pos : INTEGER;
BEGIN
  findChar(LF, str, found, pos);
  IF found THEN
    IF (pos + 1) < LEN(str) THEN
      str[pos + 1] := 0X
    END
  END;
END terminateLine;
(** Extracts characters from src after spos into dst, stopping at the first control character (ASCII < ' '). *)

PROCEDURE getTillEOL*(VAR src: ARRAY OF CHAR; spos: INTEGER; VAR dst: ARRAY OF CHAR); (* actually get till any character < ' ' *)
VAR
  i, j: INTEGER;
  l, k: LONGINT;
BEGIN
  l := Strings.Length(src);
  k := Strings.Length(dst);
 (*       Out.String("getTillEOL"); Out.Ln;
        Out.String(src); Out.Ln;
        Out.String("spos="); Out.Int(spos, 0); Out.Ln;
        Out.String("l="); Out.Int(l, 0); Out.Ln;
        Out.String("k="); Out.Int(k, 0); Out.Ln;
        Out.String("LEN(src)="); Out.Int(LEN(src), 0); Out.Ln;
        Out.String("LEN(dst)="); Out.Int(LEN(dst), 0); Out.Ln;*)
  zeroStr(dst);
  i := 0;
  j := spos+1;
  REPEAT
              (* Out.String("i="); Out.Int(i, 0); Out.Ln;
               Out.String("j="); Out.Int(j, 0); Out.Ln;
               Out.String("i+j="); Out.Int(i+j, 0); Out.Ln;
               Out.String("src[i+j]="); Out.Char(src[i+j]); Out.Ln;*)
    dst[i] := src[i+j];
    INC(i);
  UNTIL (i+j >= l) OR (src[i+j] < ' ') OR (i+j >= LEN(src)) OR (j >= LEN(dst));
END getTillEOL;

(** Extracts word from src starting at spos into dst, ending at space or control char. *)

PROCEDURE getNextWord*(VAR src: ARRAY OF CHAR; spos: INTEGER; VAR dst: ARRAY OF CHAR);
VAR
  i, j: INTEGER;
BEGIN
  zeroStr(dst);
  i := 0;
  j := spos;
  REPEAT
    dst[i] := src[i+j];
  INC(i);
  UNTIL (i+j = Strings.Length(src)) OR (src[i+j] <= ' ');
END getNextWord;


(** Copies characters from src to dst starting at spos, stopping at first non-alphanumeric or control character. *)

PROCEDURE getNextAlphaNumWord*(VAR src: ARRAY OF CHAR; spos: INTEGER; VAR dst: ARRAY OF CHAR);
VAR
  i, j: INTEGER;
  notAN: BOOLEAN;
  o: INTEGER;
BEGIN
  zeroStr(dst);
  i := 0;
  j := spos;
  notAN := FALSE;
  REPEAT
    dst[i] := src[i+j];
  INC(i);
  o := ORD(src[i+j]);
  IF ~ ( ((o >= 48) & (o <=57)) OR ((o >= 65) & (o <= 90)) OR ( (o >= 97) & (o <= 122)  ) ) THEN notAN := TRUE END;
  UNTIL (i+j = Strings.Length(src))OR notAN OR (src[i+j] <= ' ');
END getNextAlphaNumWord;

(** Scans line manually to check if pattern occurs using substring comparison. *)

PROCEDURE contains* (VAR line : ARRAY OF CHAR; pattern: ARRAY OF CHAR): BOOLEAN;
VAR
 found: BOOLEAN;
 pos : INTEGER;
 i : INTEGER;
 patternLength: INTEGER;
 tmpline: POINTER TO ARRAY OF CHAR;
BEGIN
  i := 0;
  patternLength := Strings.Length(pattern);
  NEW(tmpline, patternLength+1);
  found := FALSE;
  REPEAT
    Strings.Extract(line, i, patternLength, tmpline^);
    found := Strings.Equal(pattern, tmpline^);
    INC(i);
UNTIL found OR (i = LEN(line) - patternLength - 1);
  IF found THEN RETURN TRUE ELSE RETURN FALSE END
END contains;

(** Uses Strings.FindNext to check if pat is found in line starting at position 0. *)

PROCEDURE contains1*(VAR line: ARRAY OF CHAR; pat : ARRAY OF CHAR): BOOLEAN;
VAR
 found: BOOLEAN;
 pos : INTEGER;
BEGIN
  Strings.FindNext(pat, line, 0, found, pos);
  IF found THEN RETURN TRUE ELSE RETURN FALSE END
END contains1;

(*
PROCEDURE dumpText*(VAR text: ARRAY OF CHAR);
VAR
  i : INTEGER;
BEGIN
  i := 0;
  REPEAT
    Out.Int(i, 3); Out.String("   | ord: "); Out.Int(ORD(text[i]), 15); Out.String(", char: '"); Out.Char(text[i]); Out.Char("'"); Out.Ln;
    INC(i)
  UNTIL i = LEN(text);
END dumpText;

PROCEDURE dumpTextTill0*(VAR text: ARRAY OF CHAR);
VAR
  i : INTEGER;
BEGIN
  i := 0;
  REPEAT
    Out.Int(i, 3); Out.String("   | ord: "); Out.Int(ORD(text[i]), 15); Out.String(", char: '"); Out.Char(text[i]); Out.Char("'"); Out.Ln;
    INC(i)
  UNTIL (text[i] = 0X) OR (i = LEN(text));
END dumpTextTill0;
*)

   (* IntToStr routine taken from
   https://github.com/romiras/Oberon-F-components/blob/master/Ott/Mod/IntStr.cp
   and modified to work on 64bit system by dcwbrown,
   in order to avoid using oocIntStr, which has many dependencies *)
   PROCEDURE Reverse0 (VAR str : ARRAY OF CHAR; start, end : INTEGER);
   (* Reverses order of characters in the interval [start..end]. *)
   VAR
     h : CHAR;
   BEGIN
     WHILE start < end DO
       h := str[start]; str[start] := str[end]; str[end] := h;
       INC(start); DEC(end)
     END
   END Reverse0;

   (** Converts the value of `int' to string form and copies the possibly truncated
   result to `str'. *)
   PROCEDURE IntToStr*(int: LONGINT; VAR str: ARRAY OF CHAR);
   VAR
     b : ARRAY 21 OF CHAR;
     s, e: INTEGER;
     maxLength : SHORTINT; (* maximum number of digits representing a LONGINT value *)
   BEGIN
     IF SIZE(LONGINT) = 4 THEN maxLength := 11 END;
     IF SIZE(LONGINT) = 8 THEN maxLength := 20 END;
     (* build representation in string 'b' *)
     IF int = MIN(LONGINT) THEN (* smallest LONGINT, -int is an overflow *)
       IF SIZE(LONGINT) = 4 THEN
          b := "-2147483648";
          e := 11
       ELSE (* SIZE(LONGINT) = 8 *)
          b := "-9223372036854775808";
          e := 20
       END
     ELSE
       IF int < 0 THEN (* negative sign *)
         b[0] := "-"; int := -int; s := 1
       ELSE (* no sign *)
         s := 0
       END;
       e := s; (* 's' holds starting position of string *)
       REPEAT
         b[e] := CHR(int MOD 10+ORD("0"));
         int := int DIV 10;
         INC(e)
       UNTIL int = 0;
       b[e] := 0X;
       Reverse0(b, s, e-1);
     END;
       COPY(b, str) (* truncate output if necessary *)
   END IntToStr;

(** Prints each character in s with its index, up to the first 0X terminator. *)
PROCEDURE dumpChars*(VAR s : ARRAY OF CHAR);
VAR
  i : INTEGER;
  l : LONGINT;
BEGIN
  i := 0;
  l := Strings.Length(s);
  WHILE i < l DO
    Out.Int(i, 0); Out.Char(" "); Out.Char(s[i]); Out.Ln; INC(i)
  END
END dumpChars;

(** Prints all characters in s with their index, ignoring the 0X terminator. *)
PROCEDURE dumpAllChars*(VAR s : ARRAY OF CHAR);
VAR
  i : INTEGER;
  l : LONGINT;
BEGIN
  i := 0;
  l := LEN(s);
  WHILE i < l-1 DO
    Out.Int(i, 0); Out.Char(" "); Out.Char(s[i]); Out.Ln; INC(i)
  END
END dumpAllChars;


END strUtils.
