
class Graph

  attr_reader :edges, :nodes

  def initialize edges: {}
    @edges = edges
    @nodes = edges.keys
  end

  def neighbours node:
    @edges[node]
  end

end