
require 'twitter'
require 'octokit'
require_relative '../config/app_logger'

class ConnectedDevelopers

  attr_reader :developers

  def initialize developers:, twitter_client:, github_client:
    @twitter_client = twitter_client
    @github_client = github_client
    @developers = developers
  end

  def graph
    @graph ||= generate_graph
  end

  def friends user_name
    twitter_retry { @twitter_client.friends(user_name).entries.map{ |u| u.screen_name } }
  end

  def followers user_name
    twitter_retry { @twitter_client.followers(user_name).entries.map{ |u| u.screen_name } }
  end

  def organizations user_name
    @github_client.organizations(user_name).map{ |u| u.login }
  end

  private

  def generate_graph
     update_graph_by_friendships users_graph: create_graph_by_organizations
  end

  def create_graph_by_organizations
    users_graph = {}
    org_users = {}

    @developers.each do |user_name|
      users_graph[user_name] = []
      AppLogger.debug "GITHUB USER: #{user_name}"

      orgs = organizations(user_name)
      AppLogger.debug "ORGANIZATIONS: #{orgs}"

      orgs.each do |org|
        org_users[org] ||= []
        org_users[org] << user_name
      end

    end

    org_users.each_value { |users| users.each { |user| users_graph[user] = users_graph[user] | (users-[user]) } }

    users_graph
  end

  def update_graph_by_friendships users_graph:
    users_graph.select{ |key, users| !users.empty? }.each do |user_name, users|
      friends_names = friends(user_name)
      AppLogger.debug "FRIENDS: #{friends_names}"

      followers_names = followers(user_name)
      AppLogger.debug "FOLLOWERS: #{followers_names}"

      connected =  friends_names & followers_names & users
      users_graph[user_name] = connected
    end

    users_graph
  end

  def twitter_retry &block
    begin
      block.call
    rescue Twitter::Error::TooManyRequests => error
      # NOTE: Your process could go to sleep for up to 15 minutes but if you
      # retry any sooner, it will almost certainly fail with the same exception.
      sleep error.rate_limit.reset_in + 1
      retry
    end
  end

end