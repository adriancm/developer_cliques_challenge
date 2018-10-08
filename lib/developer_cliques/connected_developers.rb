
require 'twitter'
require 'octokit'
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

    @developers.each do |developer|
      AppLogger.debug "GITHUB USER: #{developer}"
      AppLogger.debug "ORGANIZATIONS: #{organizations(developer)}"

      excluded << developer
      developers_graph[developer] ||= []

      #Bidireccional relationship. It excludes iterated developers and itself. We look in one way only
      (@developers-excluded).each do |developer2|
        # Intersection between organizations if there are some organization in common goes in
        unless (organizations(developer) & organizations(developer2)).empty?
          #It creates relationship in one direction
          developers_graph[developer] << developer2
          # And reverse direction
          developers_graph[developer2] ||= []
          developers_graph[developer2] << developer
        end
      end

      #Intersection between friends, followers and current relationships by organizations in common
      #developers_graph[developer] &= friends(developer) & followers(developer) unless developers_graph[developer].empty?

    end

    developers_graph
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