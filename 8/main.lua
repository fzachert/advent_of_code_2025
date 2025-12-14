function distance(coordinate1, coordinate2)
    return math.sqrt((coordinate1[1]-coordinate2[1])^2 + (coordinate1[2]-coordinate2[2])^2 + (coordinate1[3]-coordinate2[3])^2)
end

function buildDistanceTable(coords)
    local distanceTable = {}
    for i = 1, #coords do
        distanceTable[i] = {}
        for j = i + 1, #coords do
            distanceTable[i][j] = distance(coords[i], coords[j])
        end
    end
    return distanceTable
end

function getMinDistance(distanceTable)
    local minDistance = math.huge
    local minI, minJ = -1, -1
    for i = 1, #distanceTable do
        for j = i + 1, #distanceTable do
            if distanceTable[i][j] and distanceTable[i][j] < minDistance then
                minDistance = distanceTable[i][j]
                minI, minJ = i, j
            end
        end
    end
    return minI, minJ, minDistance
end

function buildClusters(distanceTable, coordinates, numIterations)
    -- Placeholder for clustering logic
    clusters = {} -- each cluster is a list of point indices
    numPoints = #coordinates

    for iteration = 1, 10000000000000 do
        local
        minI, minJ, minDistance = getMinDistance(distanceTable)
        if minI == -1 or minJ == -1 then
            break
        end
        
        -- check if points are already in clusters.
        -- If they are already in the same cluster, do nothing.
        -- If they are in different clusters, merge the clusters.
        -- Otherwise, create a new cluster with these two points.
        local clusterI, clusterJ = nil, nil
        for _, cluster in ipairs(clusters) do
            local foundI, foundJ = false, false
            for _, pointIndex in ipairs(cluster) do
                if pointIndex == minI then
                    foundI = true
                end
                if pointIndex == minJ then
                    foundJ = true
                end
            end
            if foundI then
                clusterI = cluster
            end
            if foundJ then
                clusterJ = cluster
            end
        end
        if clusterI and clusterJ then
            if clusterI ~= clusterJ then
                -- merge clusters
                for _, pointIndex in ipairs(clusterJ) do
                    table.insert(clusterI, pointIndex)
                end
                -- remove clusterJ from clusters
                for i, cluster in ipairs(clusters) do
                    if cluster == clusterJ then
                        table.remove(clusters, i)
                        break
                    end
                end
            end
        elseif clusterI then
            table.insert(clusterI, minJ)
        elseif clusterJ then
            table.insert(clusterJ, minI)
        else
            table.insert(clusters, {minI, minJ})
        end

        distanceTable[minI][minJ] = nil -- Invalidate distance to avoid reprocessing

        if #clusters == 1 and #clusters[1] == numPoints then -- We are finished -> all points within one cluster
            print("All points clustered into one cluster.")
            print("Last coordinates merged:", minI, minJ)
            sumXCoords = coordinates[minI][1] * coordinates[minJ][1]
            print("Prod of X coordinates:", sumXCoords)
            break
        end

        if iteration == numIterations then
            multiplyClusterSizes(clusters, 3)
        end
    end
    return clusters
end

function printClusters(clusters)
    for i, cluster in ipairs(clusters) do
        io.write("Cluster " .. i .. ": ")
        for _, pointIndex in ipairs(cluster) do
            io.write(pointIndex .. " ")
        end
        io.write("\n")
    end
end

function multiplyClusterSizes(clusters, numClusters)
    clusterSizes = {}
    for i = 1, #clusters do
        clusterSizes[i] = #clusters[i]
    end
    table.sort(clusterSizes, function(a, b) return a > b end)
    result = 1
    for i = 1, numClusters do
        result = result * clusterSizes[i]
    end
    print("Product of cluster sizes:", result)
end

function main()
    local file = io.open("input.txt", "r")
    if not file then
        print("Error: Could not open file")
        return
    end

    coordinates = {}
    for line in file:lines() do
        -- Split line by commas and convert to numbers
        local
        words = string.gmatch(line, '([^,]+)')
        coordinate = {}
        for num in words do
            table.insert(coordinate, tonumber(num))
        end
        table.insert(coordinates, coordinate)
    end

    file:close()

    distanceTable = buildDistanceTable(coordinates)
    clusters = buildClusters(distanceTable, coordinates, 1000)
    printClusters(clusters)
end

main()