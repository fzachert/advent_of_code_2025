#include <iostream>
#include <fstream>
#include <set>
#include <list>
#include <vector>
#include <unordered_map>
#include <map>

struct Node
{
    std::vector<std::string> children;
};

struct Graph
{
    std::unordered_map<std::string, Node> nodes;

    void print()
    {
        for (const auto &pair : nodes)
        {
            std::cout << "Node: " << pair.first << " Children: ";
            for (const auto &child : pair.second.children)
            {
                std::cout << child << " ";
            }
            std::cout << std::endl;
        }
    }
};

size_t countPaths(const Graph &graph, const std::string &startNode, const std::string &endNode, std::unordered_map<std::string, size_t> &memo)
{
    if (startNode == endNode)
    {
        return 1;
    }
    if (memo.find(startNode) != memo.end())
    {
        return memo[startNode];
    }
    size_t totalPaths = 0;
    auto &node = graph.nodes.at(startNode);
    for (const auto &child : node.children)
    {
        totalPaths += countPaths(graph, child, endNode, memo);
    }
    memo[startNode] = totalPaths;
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
    Graph graph;
    std::string line;
    while (std::getline(inputFile, line))
    {
        // Process each line of the file
        std::cout << line << std::endl; // Example processing: just print the line
        std::string substr;
        std::string node;
        for (size_t i = 0; i < line.size(); ++i)
        {
            // Example character processing
            char c = line[i];
            // Do something with character c if needed
            if (c == ':')
            {
                substr = line.substr(0, i);
                node = substr;
                if (graph.nodes.find(substr) == graph.nodes.end())
                {
                    graph.nodes[node] = Node(); // Example: add node to graph
                }
                substr = ""; // Reset substring after processing
            }
            else if (c == ' ')
            {
                if (!substr.empty())
                {
                    graph.nodes[node].children.push_back(substr); // Example: add child to node

                    if (graph.nodes.find(substr) == graph.nodes.end())
                    {
                        graph.nodes[substr] = Node();
                    }
                    substr = ""; // Reset substring after processing
                }
            }
            else
            {
                substr += c;
            }
        }
        if (!substr.empty() && !node.empty())
        {
            graph.nodes[node].children.push_back(substr); // Add last substring as child
            if (graph.nodes.find(substr) == graph.nodes.end())
            {
                graph.nodes[substr] = Node();
            }
        }
    }
    graph.print();
    inputFile.close();

    std::unordered_map<std::string, size_t> memo;
    auto totalYou2Out = countPaths(graph, "you", "out", memo);
    std::cout << "Total paths from You to Out: " << totalYou2Out << std::endl;

    memo.clear();
    auto totalSvr2Fft = countPaths(graph, "svr", "fft", memo);
    std::cout << "Total paths from Svr to Fft: " << totalSvr2Fft << std::endl;

    memo.clear();
    auto totalFft2Dac = countPaths(graph, "fft", "dac", memo);
    std::cout << "Total paths from Fft to Dac: " << totalFft2Dac << std::endl;

    memo.clear();
    auto totalDac2Out = countPaths(graph, "dac", "out", memo);
    std::cout << "Total paths from Dac to Out: " << totalDac2Out << std::endl;

    auto totalPaths = totalSvr2Fft * totalFft2Dac * totalDac2Out;
    std::cout << "Total combined paths: " << totalPaths << std::endl;

    return 0;
}