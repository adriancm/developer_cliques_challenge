
require 'twitter'
require 'octokit'
require 'concurrent'
require_relative '../../config/app_logger'

class ConnectedDevelopers

  attr_reader :developers

  def initialize developers:, twitter_client:, github_client:
    @twitter_client = twitter_client
    @github_client = github_client
    @developers = developers
    @organizations = {}
  end

  def graph
    @graph ||= generate_graph
  end

  def friends user_name
    friends_list = twitter_retry { @twitter_client.friends(user_name).entries.map{ |u| u.screen_name } }
    AppLogger.debug "FRIENDS: #{friends_list}"
    friends_list
  end

  def followers user_name
    follow_list = twitter_retry { @twitter_client.followers(user_name).entries.map{ |u| u.screen_name } }
    AppLogger.debug "FRIENDS: #{follow_list}"
    follow_list
  end

  def organizations user_name
    @organizations[user_name] ||= @github_client.organizations(user_name).map{ |u| u.login }
  end

  private

  def generate_graph
    developers_graph = {}
    excluded = []

    promises = developers.map do |developer|
      excluded << developer
      developers_graph[developer] ||= []

      graph_by_developer developers_graph: developers_graph, developer: developer, excluded: excluded.clone
    end

    Concurrent::Promise.all?(*promises).execute.then{ developers_graph }
  end

  def graph_by_developer developers_graph:, developer:, excluded:
    AppLogger.debug "GITHUB USER: #{developer}"
    AppLogger.debug "ORGANIZATIONS: #{organizations(developer)}"

    Concurrent::Promise.new {
      graph_by_organization developers_graph: developers_graph,
                            remaining_devs: developers-excluded,
                            current_developer: developer
    }.then{ |relationships|
      developers_graph[developer] = twitter_friendships developer: developer, relationships: relationships
    }
  end

  def graph_by_organization developers_graph:, remaining_devs:, current_developer:
    #Bidireccional relationship. It excludes iterated developers and itself. We look only in one way
    AppLogger.debug "REMAINING DEVS: #{remaining_devs}"
    remaining_devs.each do |related_developer|
      # Intersection between organizations if there are some organization in common goes in
      unless (organizations(current_developer) & organizations(related_developer)).empty?
        #It creates relationship in one direction
        developers_graph[current_developer] << related_developer
        # And reverse direction
        developers_graph[related_developer] ||= []
        developers_graph[related_developer] << current_developer
      end
    end
    developers_graph[current_developer]
  end

  def twitter_friendships developer:, relationships:
    #Intersection between friends, followers and current relationships by organizations in common
    relationships &= friends(developer) & followers(developer) unless relationships.empty?
    relationships
  end

  def twitter_retry &block
    begin
      yield
    rescue Twitter::Error::TooManyRequests => error
      # NOTE: Your process could go to sleep for up to 15 minutes but if you
      # retry any sooner, it will almost certainly fail with the same exception.
      AppLogger.debug "TOO MANY REQUEST: #{error}. Must wait #{error.rate_limit.reset_in/60} min"
      sleep error.rate_limit.reset_in + 1
      retry
    end
  end

end