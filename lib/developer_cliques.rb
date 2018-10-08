
require_relative 'developer_cliques/connected_developers'
require_relative 'developer_cliques/graph'
require_relative '../config/twitter_config'
require_relative '../config/github_config'


class DeveloperCliques

  def initialize file:
    @file = file
  end

  def developers
    @developers ||= read_file
  end

  def max_cliques
    developers_graph = Graph.new edges: connected_developers.graph
    developers_graph.max_cliques
  end

  def connected_developers
    ConnectedDevelopers.new developers: developers,
                            twitter_client: TwitterClient.get,
                            github_client: GithubClient.get
  end

  private

  def read_file
    File.readlines(@file).map{ |line| line.strip }
  end

end

