#include <iostream>
#include <fstream>
#include <set>
#include <list>
#include <vector>
#include <unordered_map>

uint64_t calculateNumPaths(int beamPos, const std::vector<std::set<int>> &splitters, std::vector<std::unordered_map<int, uint64_t>> &memo, size_t lineIdx)
{
    if (lineIdx >= splitters.size())
    {
        return 1; // Reached the end, count as one valid path
    }
    if (memo[lineIdx].find(beamPos) != memo[lineIdx].end())
    {
        return memo[lineIdx][beamPos];
    }

    const auto &currentSplitters = splitters[lineIdx];
    uint64_t totalPaths = 0;

    // Continue straight if possible
    if (currentSplitters.find(beamPos) == currentSplitters.end())
    {
        totalPaths += calculateNumPaths(beamPos, splitters, memo, lineIdx + 1);
    }
    else
    {
        // Splitter found, branch left and right
        totalPaths += calculateNumPaths(beamPos - 1, splitters, memo, lineIdx + 1);
        totalPaths += calculateNumPaths(beamPos + 1, splitters, memo, lineIdx + 1);
    }
    memo[lineIdx][beamPos] = totalPaths;

    return totalPaths;
}

int main()
{
    std::ifstream inputFile("input.txt"); // Changed from "input.txt" to "example.txt"
    if (!inputFile.is_open())
    {
        std::cerr << "Error opening file" << std::endl;
        return 1;
    }

    std::set<int> beams;
    std::string line;
    uint32_t splitCnt = 0;
    std::vector<std::set<int>> splitters;
    int startIdx = 0;
    while (std::getline(inputFile, line))
    {
        std::set<int> nextBeams = beams;
        std::set<int> currentSplitters;
        for (size_t i = 0; i < line.size(); ++i)
        {
            if (line[i] == 'S')
            {
                nextBeams.insert(i);
                startIdx = i;
            }
            else if (line[i] == '^')
            {
                currentSplitters.insert(i);
                if (nextBeams.find(i) != nextBeams.end())
                {
                    nextBeams.erase(i);
                    nextBeams.insert(i - 1);
                    nextBeams.insert(i + 1);
                    splitCnt++;
                }
            }
        }
        if (!currentSplitters.empty())
        {
            splitters.push_back(currentSplitters);
        }

        beams = nextBeams;
    }

    inputFile.close();

    // Further processing with beams set
    std::cout << "Number of unique beams: " << beams.size() << std::endl;
    std::cout << "Number of splits: " << splitCnt << std::endl;

    std::vector<std::unordered_map<int, uint64_t>> memo(splitters.size());
    auto numPaths = calculateNumPaths(startIdx, splitters, memo, 0);
    std::cout << "Number of paths: " << numPaths << std::endl;

    return 0;
}