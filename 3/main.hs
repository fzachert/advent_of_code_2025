import System.IO

toDigit :: Char -> Int
toDigit c = read [c] :: Int

-- Reduces the length of the list by removing the first element that is smaller than its successor
reduceLengthOfList :: [Int] -> [Int]
reduceLengthOfList [] = []
reduceLengthOfList (x:[]) = []
reduceLengthOfList (x:y:zs) =  if x < y then y:zs else x:reduceLengthOfList (y:zs)

-- Get the list of the biggest consecutive elements of a given subset size
-- Parameters: current best list (nitialy empty), remaining list, size of subset
getBiggestSublist :: [Int] -> [Int] -> Int -> [Int]
getBiggestSublist currentBest [] _ = currentBest
getBiggestSublist currentBest (x:xs) size = if length currentBest < size then 
    getBiggestSublist (currentBest ++ [x]) xs size
    else getBiggestSublist (reduceLengthOfList (currentBest ++ [x])) xs size

-- Convert a list of digits to its joltage representation
listToJoltage :: [Int] -> Int
listToJoltage [] = 0
listToJoltage (x:xs) = (10 ^ (length xs)) * x + listToJoltage xs

-- Process a line to get the biggest sublist of size 2
processLine :: String -> [Int]
processLine line = getBiggestSublist [] (map toDigit line) 2

-- Process a line to get the biggest sublist of size 12
processLine2 :: String -> [Int]
processLine2 line = getBiggestSublist [] (map toDigit line) 12

main :: IO ()
main = do
    contents <- readFile "input.txt"
    let fileLines = lines contents
    mapM_ putStrLn fileLines

    -- Part 1
    let processedLines = map processLine fileLines
    let result = foldl (+) 0 (map listToJoltage processedLines)
    print ("Joltage (part 1): " ++ show result)
    
    -- Part 2
    let processedLines2 = map processLine2 fileLines
    let result2 = foldl (+) 0 (map listToJoltage processedLines2)
    print ("Joltage (part 2): " ++ show result2)