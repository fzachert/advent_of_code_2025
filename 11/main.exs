graph = File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Enum.reduce(Graph.new(), fn line, acc_graph ->
  [source, targets] = String.split(line, ": ")
  target_nodes = String.split(targets, " ")

  # Add the source vertex
  acc_graph = Graph.add_vertex(acc_graph, source)

  # Add edges to all target nodes
  Enum.reduce(target_nodes, acc_graph, fn target, g ->
    g
    |> Graph.add_vertex(target)
    |> Graph.add_edge(source, target)
  end)
end)

IO.puts("Graph created with #{Graph.num_vertices(graph)} vertices and #{Graph.num_edges(graph)} edges")

paths = Graph.get_paths(graph, "you", "out")
IO.puts("Number of paths #{length(paths)}")

# path2 = Graph.get_paths(graph, "svr", "out")
# IO.puts("Number of paths2 #{length(path2)}")
