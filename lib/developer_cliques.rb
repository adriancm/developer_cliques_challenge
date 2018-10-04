
require_relative 'developer_cliques/connected_developers'
require_relative 'developer_cliques/graph'


class DeveloperCliques

  def initialize file:
    @file = file
  end

  def developers
    @developers ||= read_file
  end

  def execute
    developers_graph = Graph.new edges: get_connected_developers.graph
    developers_graph.max_cliques
  end

  def get_connected_developers
    ConnectedDevelopers.new developers: developers,
                            twitter_client: TwitterClient.get,
                            github_client: GithubClient.get
  end

  private

  def read_file
    lines = []
    File.open(@file, "r") do |f|
      f.each do |line|
        lines << line
      end
    end
    lines
  end

end

