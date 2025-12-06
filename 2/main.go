package main

	
import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

// parse a line like "2-4,6-8" into two ranges (2,4) and (6,8)
type Range struct {
    start int
    end   int
}
func lineToRanges(line string) []Range {
    rangeList := []Range{}

    // split by comma
    ranges := strings.Split(line, ",")
    for _, r := range ranges {
        fmt.Println(r)
        // split range by -
        bounds := strings.Split(r, "-")
        fmt.Println(bounds)
        // convert to integers
        var start, end int
        fmt.Sscanf(bounds[0], "%d", &start)
        fmt.Sscanf(bounds[1], "%d", &end)
        rangeList = append(rangeList, Range{start, end})
    }
    return rangeList
}

func numberToDigitArray(n int) []int {
    digits := []int{}
    for n > 0 {
        digits = append([]int{n % 10}, digits...)
        n /= 10
    }
    return digits
}

func checkNumber1(digits []int) bool {
    if len(digits) % 2 == 1 {
        return false
    }
    mid := len(digits) / 2
    for i := 0; i < mid; i++ {
        if digits[i] != digits[mid + i] {
            return false
        }
    }
    return true
}

func checkNumber2(digits []int) bool {
    mid := len(digits) / 2
    for seqLength := 1; seqLength <= mid; seqLength++ {
        if len(digits) % seqLength != 0 {
            continue
        }

        seq := digits[0:seqLength]

        // Check if there is a repeating sequence of length seqLength
        match := true
        for seqStart := seqLength; seqStart + seqLength <= len(digits); seqStart += seqLength {
            for i := 0; i < seqLength; i++ {
                if digits[seqStart + i] != seq[i] {
                    match = false
                    break
                }
            }
        }
        if match{
            return true
        }
    }
    return false
}

func checkRange(r Range) (int, int) {
    sum1 := 0
    sum2 := 0
    for i := r.start; i <= r.end; i++ {
        digits := numberToDigitArray(i)
        if checkNumber1(digits) {
            sum1 += i
        }
        if checkNumber2(digits) {
            sum2 += i
        }
    }
    return sum1, sum2
}


func main() {
    // Read first line from input file
    file, _ := os.Open("input.txt")

    scanner := bufio.NewScanner(file)
    // optionally, resize scanner's capacity for lines over 64K, see next example
    for scanner.Scan() {
        ranges := lineToRanges(scanner.Text())
		fmt.Println(ranges)

        sum1 := 0
        sum2 := 0
        for _, r := range ranges {
            s1, s2 := checkRange(r)
            sum1 += s1
            sum2 += s2
        }
        fmt.Println("Sum1:", sum1)
        fmt.Println("Sum2:", sum2)
    }
}