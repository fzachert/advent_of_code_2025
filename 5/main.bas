REM  Hello World in BASIC

OPEN "input.txt" FOR READING AS #1
LET RANGESFINISHED = FALSE

DIM ranges(1000,2)
LET numRanges = 0
LET numberWithinRange = 0

WHILE NOT EOF(1)
    LINE INPUT #1 line$

    IF LEN(line$) = 0 THEN
        RANGESFINISHED = TRUE
        PRINT "Ranges finished."
        REM printmatrix(ranges())
        CONTINUE
    END IF

    IF NOT RANGESFINISHED THEN
        DIM tokens$(2)
        num = SPLIT(line$, tokens$(), "-")
        IF num = 2 THEN
            ranges(numRanges, 0) = VAL(tokens$(1))
            ranges(numRanges, 1) = VAL(tokens$(2))
            numRanges = numRanges + 1
        ELSE
            PRINT "Invalid range format."
        END IF
    ELSE
        LET value = VAL(line$)
        FOR i = 0 TO numRanges - 1
            IF value >= ranges(i, 0) AND value <= ranges(i, 1) THEN
                numberWithinRange = numberWithinRange + 1
                BREAK
            END IF
        NEXT i

    END IF

    REM Process line$ here
WEND
CLOSE #1
PRINT "Total numbers within ranges: ", numberWithinRange

sub printmatrix(ar())
  local x,y,p,q
  x=arraysize(ar(),1)
  y=arraysize(ar(),2)
  for q=0 to y
    for p=0 to x
      print ar(p,q),"\t";
    next p
    print
  next q
end sub
