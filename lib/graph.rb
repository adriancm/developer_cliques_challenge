
class Graph

  attr_reader :edges, :nodes

  def initialize edges: {}
    @edges = edges
    @nodes = edges.keys
  end

  def neighbours node:
    @edges[node] || []
  end

  def max_cliques
    @cliques ||= []
    bron_kerbosch(possibles: nodes) if @cliques.empty?
    @cliques
  end

  private

  # Bron-Kerbosch Algorithm with Pivoting
  # @param result
  # is the set with the nodes of a maximal clique
  # @param possibles
  # is the set of the possible nodes to look
  # @param excluded
  # is the set of the excluded nodes
  def bron_kerbosch result: [], possibles: [], excluded: []
    @cliques << result if possibles.empty? and excluded.empty?

    #Pivoting: it takes first element of possibles as pivot
    (possibles - neighbours(node: possibles.first)).each do |n|
      # Recursive call
      bron_kerbosch result: result | [n],
                    possibles: possibles & neighbours(node: n),
                    excluded: excluded & neighbours(node: n)

      possibles -= [n]
      excluded |= [n]
    end
  end

end