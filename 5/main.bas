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

combinedCount = combineOverlapsLoop(ranges(), numRanges)

LET totalRange = 0
FOR i = 0 TO combinedCount - 1
    totalRange = totalRange + (ranges(i, 1) - ranges(i, 0) + 1)
NEXT i
PRINT "Total range covered: ", totalRange USING "####################"

SUB combineOverlapsLoop(ranges(), numRanges)
    DIM combinedRanges(1000,2)
    LET combinedCount = 2
    while TRUE

        LET prevCount = combinedCount
        combinedCount = combineOverlaps(ranges(), numRanges, combinedRanges())

        FOR i = 0 TO combinedCount - 1
            ranges(i, 0) = combinedRanges(i, 0)
            ranges(i, 1) = combinedRanges(i, 1)
        NEXT i
        numRanges = combinedCount

        IF combinedCount = prevCount THEN
            BREAK
        END IF
    WEND
    RETURN combinedCount
END SUB

SUB combineOverlaps(ranges(), numRanges, combinedRanges())
    LOCAL wasMerged(1000)
    combinedCount = 0

    FOR i = 0 TO numRanges - 1
        IF wasMerged(i) THEN
            CONTINUE
        END IF

        LET hasOverlap = FALSE
        FOR j = i + 1 TO numRanges - 1
            IF wasMerged(j) THEN
                CONTINUE
            END IF

            REM Check for overlap
            IF NOT (ranges(i, 1) < ranges(j, 0) OR ranges(j, 1) < ranges(i, 0)) THEN
                REM There is an overlap
                combinedStart = MIN(ranges(i, 0), ranges(j, 0))
                combinedEnd = MAX(ranges(i, 1), ranges(j, 1))
                combinedRanges(combinedCount, 0) = combinedStart
                combinedRanges(combinedCount, 1) = combinedEnd
                combinedCount = combinedCount + 1
                hasOverlap = TRUE
                wasMerged(j) = TRUE
                BREAK
            END IF
        NEXT j
        IF NOT hasOverlap THEN
            combinedRanges(combinedCount, 0) = ranges(i, 0)
            combinedRanges(combinedCount, 1) = ranges(i, 1)
            combinedCount = combinedCount + 1
        END IF
    NEXT i
    RETURN combinedCount
END SUB
